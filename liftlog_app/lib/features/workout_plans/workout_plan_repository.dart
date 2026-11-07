import '../../core/api_client.dart';
import 'models/program_template.dart';

class WorkoutPlanRepository {
  WorkoutPlanRepository(this._api);
  final ApiClient _api;

  Future<Recommendation> recommendation() async {
    final res = await _api.get('/recommendation');
    return Recommendation(
      match: res['match'] as String,
      template: ProgramTemplate.fromJson(Map<String, dynamic>.from(res['template'] as Map)),
    );
  }

  Future<List<ProgramTemplate>> templates() async {
    final res = await _api.get('/program-templates');
    return (res as List)
        .map((e) => ProgramTemplate.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  /// Menyalin template ke rencana aktif. `weekdays`: Senin = 1.
  Future<void> generate({required List<int> weekdays, required int templateId}) async {
    await _api.post('/workout-plans/generate', data: {
      'weekdays': weekdays,
      'template_id': templateId,
    });
  }
}