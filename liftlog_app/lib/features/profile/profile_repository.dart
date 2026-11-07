import '../../core/api_client.dart';

class ProfileRepository {
  ProfileRepository(this._api);
  final ApiClient _api;

  /// Menyimpan hasil onboarding. `level` dihitung server dari experience + frequency.
  /// `training_weekdays` hanya mengisi `training_days_count`; hari-harinya
  /// disimpan di plan_schedules saat rencana dibuat.
  Future<void> saveOnboarding({
    required String goal,
    required int experience,
    required int frequency,
    required List<int> trainingWeekdays,
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
  }) async {
    await _api.put('/profile', data: {
      'goal': goal,
      'experience': experience,
      'frequency': frequency,
      'training_weekdays': trainingWeekdays,
      'weight_kg': weightKg,
      'height_cm': heightCm,
      'age': age,
      'gender': gender,
      'activity_level': activityLevel,
    });
  }
}