class ProgramTemplateItem {
  const ProgramTemplateItem({
    required this.id,
    required this.dayNumber,
    required this.position,
    required this.targetSets,
    this.targetReps,
    this.targetDurationSeconds,
    this.weightKg,
    required this.exerciseName,
    required this.exerciseType,
    required this.exerciseKind,
    this.cameraPosition,
  });

  final int id;
  final int dayNumber;
  final int position;
  final int targetSets;
  final int? targetReps;
  final int? targetDurationSeconds;
  final double? weightKg;
  final String exerciseName;
  final String exerciseType; // bodyweight | dumbbell
  final String exerciseKind; // reps | duration
  final String? cameraPosition; // side | front

  bool get isDumbbell => exerciseType == 'dumbbell';

  factory ProgramTemplateItem.fromJson(Map<String, dynamic> j) {
    final ex = (j['exercise'] as Map?) ?? const {};
    return ProgramTemplateItem(
      id: (j['id'] as num).toInt(),
      dayNumber: (j['day_number'] as num).toInt(),
      position: (j['position'] as num).toInt(),
      targetSets: (j['target_sets'] as num).toInt(),
      targetReps: (j['target_reps'] as num?)?.toInt(),
      targetDurationSeconds: (j['target_duration_seconds'] as num?)?.toInt(),
      weightKg: (j['weight_kg'] as num?)?.toDouble(),
      exerciseName: (ex['name'] ?? '') as String,
      exerciseType: (ex['type'] ?? '') as String,
      exerciseKind: (ex['kind'] ?? '') as String,
      cameraPosition: ex['camera_position'] as String?,
    );
  }
}

class ProgramTemplate {
  const ProgramTemplate({
    required this.id,
    required this.name,
    required this.level,
    required this.goal,
    required this.days,
    required this.items,
  });

  final int id;
  final String name;
  final String level; // beginner | intermediate | advanced
  final String goal; // muscle | stamina | general
  final int days;
  final List<ProgramTemplateItem> items;

  factory ProgramTemplate.fromJson(Map<String, dynamic> j) => ProgramTemplate(
        id: (j['id'] as num).toInt(),
        name: j['name'] as String,
        level: j['level'] as String,
        goal: j['goal'] as String,
        days: (j['days'] as num).toInt(),
        items: ((j['items'] as List?) ?? const [])
            .map((e) => ProgramTemplateItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
      );

  List<ProgramTemplateItem> itemsOfDay(int day) =>
      items.where((i) => i.dayNumber == day).toList()
        ..sort((a, b) => a.position.compareTo(b.position));

  int get totalSets => items.fold(0, (s, i) => s + i.targetSets);

  /// Perkiraan durasi rata-rata per sesi (menit, dibulatkan ke 5).
  int get estimatedMinutes => days == 0 ? 0 : minutesForSets((totalSets / days).round());

  /// Perkiraan kasar: ±2,5 menit per set (kerja plus istirahat).
  static int minutesForSets(int sets) => ((sets * 2.5) / 5).round() * 5;

  String equipmentLabel({bool short = false}) => equipmentOf(items, short: short);
}

class Recommendation {
  const Recommendation({required this.match, required this.template});

  /// exact | level_days | beginner_days | beginner_nearest
  final String match;
  final ProgramTemplate template;
}

String levelLabel(String level) => switch (level) {
      'beginner' => 'pemula',
      'intermediate' => 'menengah',
      'advanced' => 'lanjut',
      _ => level,
    };

String goalLabel(String goal) => switch (goal) {
      'muscle' => 'menguatkan otot',
      'stamina' => 'stamina',
      'general' => 'bentuk tubuh umum',
      _ => goal,
    };

String equipmentOf(Iterable<ProgramTemplateItem> items, {bool short = false}) {
  final dumbbell = items.any((i) => i.isDumbbell);
  final body = items.any((i) => !i.isDumbbell);
  if (dumbbell && body) return short ? 'Campuran' : 'Beban tubuh & dumbbell';
  return dumbbell ? 'Dumbbell' : 'Beban tubuh';
}

const _lowerBody = {'Squat', 'Dumbbell Squat'};
const _core = {'Crunch', 'Forearm Plank'};

/// Judul sesi diturunkan dari gerakan yang ada (tabel template tidak punya kolom judul hari).
String dayTitle(Iterable<ProgramTemplateItem> items) {
  final names = items.map((i) => i.exerciseName).toSet();
  final lower = names.any(_lowerBody.contains);
  final core = names.any(_core.contains);
  final upper = names.any((n) => !_lowerBody.contains(n) && !_core.contains(n));
  if (lower && upper) return 'FULL BODY';
  if (lower) return core ? 'KAKI & INTI' : 'KAKI';
  if (upper) return core ? 'ATAS & INTI' : 'BADAN ATAS';
  return 'INTI';
}

String cameraLabel(Iterable<ProgramTemplateItem> items) {
  final pos = items.map((i) => i.cameraPosition).whereType<String>().toSet();
  if (pos.contains('side') && pos.contains('front')) return 'KAMERA SAMPING & DEPAN';
  if (pos.contains('front')) return 'KAMERA DEPAN';
  if (pos.contains('side')) return 'KAMERA SAMPING';
  return '';
}