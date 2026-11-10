import 'plan_item.dart';
import 'plan_schedule.dart';

class WorkoutPlan {
  const WorkoutPlan({required this.id, required this.name, required this.daysPerWeek});

  final int id;
  final String name;
  final int daysPerWeek;

  factory WorkoutPlan.fromJson(Map<String, dynamic> j) => WorkoutPlan(
        id: int.parse('${j['id']}'),
        name: j['name'] as String,
        daysPerWeek: int.parse('${j['days_per_week']}'),
      );
}

/// Ringkasan sesi yang selesai hari ini (diisi server bila ada).
class TodaySession {
  const TodaySession({
    required this.id,
    this.formScore,
    required this.validReps,
    required this.durationMinutes,
    required this.volumeKg,
    this.endedAt,
  });

  final int id;
  final double? formScore; // 0..1
  final int validReps;
  final int durationMinutes;
  final double volumeKg;
  final DateTime? endedAt;

  factory TodaySession.fromJson(Map<String, dynamic> j) => TodaySession(
        id: int.parse('${j['id']}'),
        formScore: j['form_score'] == null ? null : double.tryParse('${j['form_score']}'),
        validReps: int.tryParse('${j['valid_reps'] ?? 0}') ?? 0,
        durationMinutes: int.tryParse('${j['duration_minutes'] ?? 0}') ?? 0,
        volumeKg: double.tryParse('${j['volume_kg'] ?? 0}') ?? 0,
        endedAt: j['ended_at'] == null ? null : DateTime.parse(j['ended_at'] as String).toLocal(),
      );
}

class TodayWorkout {
  const TodayWorkout({
    this.plan,
    required this.weekday,
    required this.scheduled,
    this.dayNumber,
    required this.schedules,
    required this.items,
    this.session,
  });

  final WorkoutPlan? plan;
  final int weekday; // Senin = 1
  final bool scheduled;
  final int? dayNumber;
  final List<PlanSchedule> schedules;
  final List<PlanItem> items;
  final TodaySession? session;

  factory TodayWorkout.fromJson(Map<String, dynamic> j) => TodayWorkout(
        plan: j['plan'] == null
            ? null
            : WorkoutPlan.fromJson(Map<String, dynamic>.from(j['plan'] as Map)),
        weekday: int.parse('${j['weekday']}'),
        scheduled: j['scheduled'] == true,
        dayNumber: j['day_number'] == null ? null : int.parse('${j['day_number']}'),
        schedules: ((j['schedules'] as List?) ?? const [])
            .map((e) => PlanSchedule.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        items: ((j['items'] as List?) ?? const [])
            .map((e) => PlanItem.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList(),
        session: j['session'] == null
            ? null
            : TodaySession.fromJson(Map<String, dynamic>.from(j['session'] as Map)),
      );
}