class PlanSchedule {
  const PlanSchedule({required this.weekday, required this.dayNumber});

  final int weekday; // Senin = 1
  final int dayNumber;

  factory PlanSchedule.fromJson(Map<String, dynamic> j) => PlanSchedule(
        weekday: int.parse('${j['weekday']}'),
        dayNumber: int.parse('${j['day_number']}'),
      );
}