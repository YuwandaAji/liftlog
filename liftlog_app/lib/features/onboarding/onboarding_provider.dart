import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import '../profile/profile_repository.dart';

class OnboardingProvider extends ChangeNotifier {
  OnboardingProvider(this._repo);
  final ProfileRepository _repo;

  static const stepCount = 4;
  static const minWeight = 20.0, maxWeight = 300.0;
  static const minHeight = 100.0, maxHeight = 250.0;
  static const minAge = 13.0, maxAge = 100.0;

  int step = 0;

  String? goal; // muscle | stamina | general
  int? experience; // 0-2
  int? frequency; // 0-2
  final Set<int> weekdays = {}; // 1-7, Senin = 1 (ditahan sampai tahap generate rencana)

  String weightText = '';
  String heightText = '';
  String ageText = '';
  String? gender; // male | female
  String? activityLevel; // sedentary | light | moderate | active

  bool loading = false;
  String? error;

  bool get isLast => step == stepCount - 1;
  List<int> get sortedWeekdays => weekdays.toList()..sort();

  static double? _num(String s) => double.tryParse(s.trim().replaceAll(',', '.'));
  double? get weightKg => _num(weightText);
  double? get heightCm => _num(heightText);
  int? get age => int.tryParse(ageText.trim());

  static bool _in(num? v, double min, double max) => v != null && v >= min && v <= max;

  bool get bodyValid =>
      _in(weightKg, minWeight, maxWeight) &&
      _in(heightCm, minHeight, maxHeight) &&
      _in(age, minAge, maxAge);

  bool get canProceed => switch (step) {
        0 => goal != null,
        1 => experience != null,
        2 => frequency != null && weekdays.length >= 2 && weekdays.length <= 4,
        _ => bodyValid && gender != null && activityLevel != null,
      };

  void setGoal(String v) => _set(() => goal = v);
  void setExperience(int v) => _set(() => experience = v);
  void setFrequency(int v) => _set(() => frequency = v);
  void setGender(String v) => _set(() => gender = v);
  void setActivityLevel(String v) => _set(() => activityLevel = v);

  void toggleWeekday(int day) =>
      _set(() => weekdays.contains(day) ? weekdays.remove(day) : weekdays.add(day));

  void setWeight(String v) => _set(() => weightText = v);
  void setHeight(String v) => _set(() => heightText = v);
  void setAge(String v) => _set(() => ageText = v);

  void next() {
    if (canProceed && !isLast) _set(() => step++);
  }

  void back() {
    if (step > 0) _set(() => step--);
  }

  Future<bool> submit() async {
    if (!canProceed) return false;
    loading = true;
    error = null;
    notifyListeners();
    try {
      await _repo.saveOnboarding(
        goal: goal!,
        experience: experience!,
        frequency: frequency!,
        trainingWeekdays: sortedWeekdays,
        weightKg: weightKg!,
        heightCm: heightCm!,
        age: age!,
        gender: gender!,
        activityLevel: activityLevel!,
      );
      return true;
    } on ApiException catch (e) {
      error = e.message;
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void _set(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}