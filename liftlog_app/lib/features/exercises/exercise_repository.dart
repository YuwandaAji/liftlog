import '../../core/api_client.dart';
import 'models/exercise.dart';

class ExerciseRepository {
  ExerciseRepository(this._api);
  final ApiClient _api;

  Future<List<Exercise>> list() async {
    final res = await _api.get('/exercises');
    return (res as List)
        .map((e) => Exercise.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}