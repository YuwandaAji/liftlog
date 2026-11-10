class WeeklyStats {
  const WeeklyStats({
    required this.sessionsDone,
    required this.sessionsTarget,
    required this.validReps,
    this.validRepsDelta,
    this.avgFormScore,
    this.streakDays = 0,
    this.doneWeekdays = const [],
  });

  final int sessionsDone;
  final int sessionsTarget;
  final int validReps;
  final int? validRepsDelta; // selisih terhadap minggu lalu
  final double? avgFormScore; // 0..1
  final int streakDays;
  final List<int> doneWeekdays; // Senin = 1

  factory WeeklyStats.fromJson(Map<String, dynamic> j) {
    int? i(String k) => j[k] == null ? null : int.tryParse('${j[k]}');
    return WeeklyStats(
      sessionsDone: i('sessions_done') ?? 0,
      sessionsTarget: i('sessions_target') ?? 0,
      validReps: i('valid_reps') ?? 0,
      validRepsDelta: i('valid_reps_delta'),
      avgFormScore: j['avg_form_score'] == null ? null : double.tryParse('${j['avg_form_score']}'),
      streakDays: i('streak_days') ?? 0,
      doneWeekdays: ((j['done_weekdays'] as List?) ?? const [])
          .map((e) => int.parse('$e'))
          .toList(),
    );
  }
}