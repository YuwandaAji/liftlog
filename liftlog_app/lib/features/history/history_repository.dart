import '../../core/api_client.dart';
import 'models/personal_record.dart';
import 'models/weekly_stats.dart';

class HistoryRepository {
  HistoryRepository(this._api);
  final ApiClient _api;

  Future<WeeklyStats> weeklyStats() async {
    final res = await _api.get('/stats/weekly');
    return WeeklyStats.fromJson(Map<String, dynamic>.from(res as Map));
  }

  /// Daftar rekor diurutkan terbaru lebih dulu; yang dikembalikan hanya yang pertama.
  Future<PersonalRecord?> latestRecord() async {
    final res = await _api.get('/personal-records');
    final list = res as List;
    if (list.isEmpty) return null;
    return PersonalRecord.fromJson(Map<String, dynamic>.from(list.first as Map));
  }
}