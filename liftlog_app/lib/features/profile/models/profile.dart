import '../../../core/utils/body_calculator.dart';

class Profile {
  const Profile({
    this.goal,
    this.level,
    this.weightKg,
    this.heightCm,
    this.age,
    this.gender,
    this.activityFactor,
  });

  final String? goal;
  final String? level;
  final double? weightKg;
  final double? heightCm;
  final int? age;
  final String? gender;
  final double? activityFactor;

  /// Menerima respons langsung `{...}` maupun `{profile: {...}}`.
  factory Profile.fromJson(dynamic json) {
    final map = (json is Map && json['profile'] is Map) ? json['profile'] as Map : json as Map;
    double? d(String k) => map[k] == null ? null : double.tryParse('${map[k]}');
    int? i(String k) => map[k] == null ? null : int.tryParse('${map[k]}');
    return Profile(
      goal: map['goal'] as String?,
      level: map['level'] as String?,
      weightKg: d('weight_kg'),
      heightCm: d('height_cm'),
      age: i('age'),
      gender: map['gender'] as String?,
      activityFactor: d('activity_factor'),
    );
  }

  /// null bila data tubuh belum lengkap.
  BodyNeeds? get needs {
    final w = weightKg, h = heightCm, a = age, g = gender, f = activityFactor;
    if (w == null || h == null || a == null || g == null || f == null) return null;
    return BodyCalculator.calculate(
      weightKg: w,
      heightCm: h,
      age: a,
      gender: g,
      activityFactor: f,
    );
  }
}