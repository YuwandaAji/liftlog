import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import 'models/program_template.dart';
import 'workout_plan_repository.dart';

class WorkoutPlanProvider extends ChangeNotifier {
  WorkoutPlanProvider(this._repo);
  final WorkoutPlanRepository _repo;

  ProgramTemplate? selected;
  String? match; // exact | level_days | beginner_days | beginner_nearest | chosen
  List<ProgramTemplate> templates = [];

  bool loading = true; // memuat rekomendasi
  bool loadingList = false; // memuat daftar template
  bool applying = false; // membuat rencana
  String? error;

  Future<void> loadRecommendation() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final r = await _repo.recommendation();
      selected = r.template;
      match = r.match;
    } on ApiException catch (e) {
      error = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> loadTemplates() async {
    if (templates.isNotEmpty) return true;
    loadingList = true;
    error = null;
    notifyListeners();
    try {
      templates = await _repo.templates();
      return true;
    } on ApiException catch (e) {
      error = e.message;
      return false;
    } finally {
      loadingList = false;
      notifyListeners();
    }
  }

  void select(ProgramTemplate t) {
    selected = t;
    match = 'chosen';
    error = null;
    notifyListeners();
  }

  Future<bool> apply(List<int> weekdays) async {
    final t = selected;
    if (t == null) return false;
    applying = true;
    error = null;
    notifyListeners();
    try {
      await _repo.generate(weekdays: weekdays, templateId: t.id);
      return true;
    } on ApiException catch (e) {
      error = e.message;
      return false;
    } finally {
      applying = false;
      notifyListeners();
    }
  }
}