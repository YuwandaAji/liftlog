class PlanItem {
  const PlanItem({
    required this.id,
    required this.dayNumber,
    required this.position,
    required this.targetSets,
    this.targetReps,
    this.targetDurationSeconds,
    this.weightKg,
    required this.restSeconds,
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
  final int restSeconds;
  final String exerciseName;
  final String exerciseType; // bodyweight | dumbbell
  final String exerciseKind; // reps | duration
  final String? cameraPosition; // side | front

  factory PlanItem.fromJson(Map<String, dynamic> j) {
    final ex = (j['exercise'] as Map?) ?? const {};
    int? i(String k) => j[k] == null ? null : int.tryParse('${j[k]}');
    return PlanItem(
      id: i('id')!,
      dayNumber: i('day_number')!,
      position: i('position')!,
      targetSets: i('target_sets')!,
      targetReps: i('target_reps'),
      targetDurationSeconds: i('target_duration_seconds'),
      weightKg: j['weight_kg'] == null ? null : double.tryParse('${j['weight_kg']}'),
      restSeconds: i('rest_seconds') ?? 60,
      exerciseName: (ex['name'] ?? '') as String,
      exerciseType: (ex['type'] ?? '') as String,
      exerciseKind: (ex['kind'] ?? '') as String,
      cameraPosition: ex['camera_position'] as String?,
    );
  }

  /// "3 × 10" atau "3 × 30s"
  String get targetLabel => targetDurationSeconds != null
      ? '$targetSets × ${targetDurationSeconds}s'
      : '$targetSets × ${targetReps ?? '-'}';

  String get cameraText => switch (cameraPosition) {
        'side' => 'SAMPING',
        'front' => 'DEPAN',
        _ => '',
      };
}