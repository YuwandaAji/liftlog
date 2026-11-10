class PersonalRecord {
  const PersonalRecord({
    required this.exerciseName,
    required this.metric,
    required this.value,
    this.delta,
    required this.achievedAt,
  });

  final String exerciseName;
  final String metric; // weight | reps
  final double value;
  final double? delta;
  final DateTime achievedAt;

  factory PersonalRecord.fromJson(Map<String, dynamic> j) => PersonalRecord(
        exerciseName: j['exercise_name'] as String,
        metric: j['metric'] as String,
        value: double.parse('${j['value']}'),
        delta: j['delta'] == null ? null : double.tryParse('${j['delta']}'),
        achievedAt: DateTime.parse(j['achieved_at'] as String).toLocal(),
      );

  String _num(double v) => v % 1 == 0 ? v.toInt().toString() : v.toStringAsFixed(1);

  String get valueLabel => _num(value);
  String get unit => metric == 'weight' ? 'KG' : 'REP';

  String? get deltaLabel {
    final d = delta;
    if (d == null || d <= 0) return null;
    return metric == 'weight' ? '+${_num(d)} KG BEBAN' : '+${_num(d)} REP';
  }

  int get daysAgo {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day)
        .difference(DateTime(achievedAt.year, achievedAt.month, achievedAt.day))
        .inDays;
  }

  /// Rekor dianggap "baru" bila tercapai dalam 7 hari terakhir.
  bool get isRecent => daysAgo <= 7;

  String get whenLabel => switch (daysAgo) {
        0 => 'HARI INI',
        1 => 'KEMARIN',
        _ => '$daysAgo HARI LALU',
      };
}