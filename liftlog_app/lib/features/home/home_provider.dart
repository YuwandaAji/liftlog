import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../../core/utils/body_calculator.dart';
import '../history/history_repository.dart';
import '../history/models/personal_record.dart';
import '../history/models/weekly_stats.dart';
import '../profile/profile_repository.dart';
import '../workout_plans/models/workout_plan.dart';
import '../workout_plans/workout_plan_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider({required this.plans, required this.profiles, required this.history});

  final WorkoutPlanRepository plans;
  final ProfileRepository profiles;
  final HistoryRepository history;

  TodayWorkout? today;
  BodyNeeds? needs;
  WeeklyStats? stats;
  PersonalRecord? record;

  bool loading = true;
  String? error;

  Future<T?> _soft<T>(Future<T> Function() f) async {
    try {
      return await f();
    } on ApiException {
      return null;
    }
  }

  Future<void> load() async {
    if (today == null) {
      loading = true;
      notifyListeners();
    }
    error = null;

    final todayF = plans.today();
    final needsF = _soft(() async => (await profiles.fetch()).needs);
    final statsF = _soft(history.weeklyStats);
    final recordF = _soft(history.latestRecord);

    try {
      today = await todayF;
    } on ApiException catch (e) {
      if (today == null) error = e.message;
    }
    needs = await needsF;
    stats = await statsF;
    record = await recordF;

    loading = false;
    notifyListeners();
  }
}