class BodyNeeds {
  const BodyNeeds({required this.bmr, required this.tdee, required this.proteinGrams});

  final int bmr;
  final int tdee;
  final int proteinGrams;
}

class BodyCalculator {
  static BodyNeeds calculate({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender, // male | female
    required double activityFactor,
  }) {
    final base = 10 * weightKg + 6.25 * heightCm - 5 * age;
    final bmr = gender == 'female' ? base - 161 : base + 5;
    return BodyNeeds(
      bmr: bmr.round(),
      tdee: (bmr * activityFactor).round(),
      proteinGrams: (1.6 * weightKg).round(),
    );
  }
}