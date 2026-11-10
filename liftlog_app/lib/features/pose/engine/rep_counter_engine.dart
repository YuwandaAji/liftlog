import 'dart:math' as math;
import 'form_score.dart';

enum CounterMode {
  /// Dua zona sudut (lutut, siku, lengan-badan, dst.).
  zone,

  /// Crunch: selisih dari baseline berbaring yang dikalibrasi di awal set.
  baselineDelta,

  /// Plank: timer berjalan hanya saat sudut berada di rentang lower..upper.
  durationRange,
}

enum RepEvent { none, valid, partial }

enum _Zone { low, mid, high }

class EngineConfig {
  const EngineConfig({
    required this.mode,
    required this.lowerAngle,
    required this.upperAngle,
    this.smoothingAlpha = 0.5,
    this.minExcursionFraction = 0.25,
    this.baselineFrames = 15,
    this.maxGapMs = 1000,
  });

  final CounterMode mode;

  /// zone: batas zona sudut kecil (sudut <= nilai ini).
  /// baselineDelta: pengurangan sudut minimal agar rep valid.
  /// durationRange: batas bawah rentang timer.
  final double lowerAngle;

  /// zone: batas zona sudut besar (sudut >= nilai ini).
  /// baselineDelta: toleransi untuk dianggap kembali ke baseline.
  /// durationRange: batas atas rentang timer.
  final double upperAngle;

  /// Penghalus EMA: 1 = tanpa penghalusan, makin kecil makin halus.
  final double smoothingAlpha;

  /// Gerak keluar zona awal baru dihitung "kurang" bila menempuh minimal
  /// bagian ini dari lebar rentang (mengabaikan getaran kecil di sekitar ambang).
  final double minExcursionFraction;

  final int baselineFrames; // jumlah frame kalibrasi crunch
  final int maxGapMs; // batas selisih waktu antar frame yang dihitung timer plank

  /// Memilih mode dari baris tabel `exercises`.
  /// Catatan: crunch dikenali dari namanya karena tabel belum punya kolom mode.
  factory EngineConfig.fromExercise({
    required String name,
    required String kind, // reps | duration
    required double lowerAngle,
    required double upperAngle,
    double smoothingAlpha = 0.5,
  }) {
    final mode = kind == 'duration'
        ? CounterMode.durationRange
        : (name.trim().toLowerCase() == 'crunch'
            ? CounterMode.baselineDelta
            : CounterMode.zone);
    return EngineConfig(
      mode: mode,
      lowerAngle: lowerAngle,
      upperAngle: upperAngle,
      smoothingAlpha: smoothingAlpha,
    );
  }
}

class RepCounterEngine {
  RepCounterEngine(this.config);

  final EngineConfig config;

  int totalReps = 0;
  int validReps = 0;
  int _heldMs = 0;
  bool inRange = false; // khusus durationRange: sedang dalam rentang yang benar

  double? _smoothed;

  // zone
  _Zone? _start; // zona awal = zona pertama yang tercapai
  bool _away = false;
  bool _reachedOpposite = false;
  double _excursion = 0;

  // baselineDelta
  final List<double> _baselineSamples = [];
  double? _baseline;
  double _maxDelta = 0;

  // durationRange
  DateTime? _lastAt;
  bool _lastInRange = false;

  double? get formScore => computeFormScore(validReps, totalReps);
  Duration get heldDuration => Duration(milliseconds: _heldMs);
  bool get isCalibrating => config.mode == CounterMode.baselineDelta && _baseline == null;

  void reset() {
    totalReps = 0;
    validReps = 0;
    _heldMs = 0;
    inRange = false;
    _smoothed = null;
    _start = null;
    _away = false;
    _reachedOpposite = false;
    _excursion = 0;
    _baselineSamples.clear();
    _baseline = null;
    _maxDelta = 0;
    _lastAt = null;
    _lastInRange = false;
  }

  /// Masukkan satu sudut per frame. Mengembalikan [RepEvent.valid] atau
  /// [RepEvent.partial] saat satu siklus selesai, selain itu [RepEvent.none].
  /// [at] dipakai mode durasi (bawaan: waktu sekarang).
  RepEvent update(double angle, {DateTime? at}) {
    if (angle.isNaN) return RepEvent.none;

    final prev = _smoothed;
    final a = prev == null
        ? angle
        : config.smoothingAlpha * angle + (1 - config.smoothingAlpha) * prev;
    _smoothed = a;

    return switch (config.mode) {
      CounterMode.zone => _updateZone(a),
      CounterMode.baselineDelta => _updateBaseline(a),
      CounterMode.durationRange => _updateDuration(a, at ?? DateTime.now()),
    };
  }

  RepEvent _updateZone(double a) {
    final lower = config.lowerAngle, upper = config.upperAngle;
    final zone = a <= lower ? _Zone.low : (a >= upper ? _Zone.high : _Zone.mid);

    if (_start == null) {
      if (zone != _Zone.mid) _start = zone;
      return RepEvent.none;
    }

    final opposite = _start == _Zone.low ? _Zone.high : _Zone.low;

    if (zone == _start) {
      if (!_away) return RepEvent.none;
      final minExcursion = config.minExcursionFraction * (upper - lower).abs();
      final event = _reachedOpposite
          ? RepEvent.valid
          : (_excursion >= minExcursion ? RepEvent.partial : RepEvent.none);
      _away = false;
      _reachedOpposite = false;
      _excursion = 0;
      return _count(event);
    }

    if (!_away) {
      _away = true;
      _excursion = 0;
      _reachedOpposite = false;
    }
    final startThreshold = _start == _Zone.low ? lower : upper;
    _excursion = math.max(_excursion, (a - startThreshold).abs());
    if (zone == opposite) _reachedOpposite = true;
    return RepEvent.none;
  }

  RepEvent _updateBaseline(double a) {
    if (_baseline == null) {
      _baselineSamples.add(a);
      if (_baselineSamples.length >= config.baselineFrames) {
        _baseline = _baselineSamples.reduce((x, y) => x + y) / _baselineSamples.length;
      }
      return RepEvent.none;
    }

    final delta = _baseline! - a; // sudut mengecil saat crunch
    final required = config.lowerAngle;
    final tolerance = config.upperAngle;

    if (!_away) {
      if (delta > tolerance) {
        _away = true;
        _maxDelta = delta;
      }
      return RepEvent.none;
    }

    _maxDelta = math.max(_maxDelta, delta);
    if (delta <= tolerance) {
      final event = _maxDelta >= required
          ? RepEvent.valid
          : (_maxDelta >= required * 0.5 ? RepEvent.partial : RepEvent.none);
      _away = false;
      _maxDelta = 0;
      return _count(event);
    }
    return RepEvent.none;
  }

  RepEvent _updateDuration(double a, DateTime at) {
    final last = _lastAt;
    if (last != null && _lastInRange) {
      final dt = at.difference(last).inMilliseconds;
      _heldMs += math.min(math.max(dt, 0), config.maxGapMs);
    }
    _lastAt = at;
    inRange = a >= config.lowerAngle && a <= config.upperAngle;
    _lastInRange = inRange;
    return RepEvent.none;
  }

  RepEvent _count(RepEvent event) {
    if (event == RepEvent.valid) {
      validReps++;
      totalReps++;
    } else if (event == RepEvent.partial) {
      totalReps++;
    }
    return event;
  }
}