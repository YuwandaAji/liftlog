import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import 'exercise_repository.dart';
import 'models/exercise.dart';

class ExerciseProvider extends ChangeNotifier {
  ExerciseProvider(this._repo);
  final ExerciseRepository _repo;

  List<Exercise> all = [];
  String? type; // null = semua; bodyweight | dumbbell
  bool loading = true;
  String? error;

  List<Exercise> get filtered =>
      type == null ? all : all.where((e) => e.type == type).toList();

  int count(String? t) => t == null ? all.length : all.where((e) => e.type == t).length;

  Future<void> load() async {
    if (all.isEmpty) {
      loading = true;
      notifyListeners();
    }
    error = null;
    try {
      all = await _repo.list();
    } on ApiException catch (e) {
      if (all.isEmpty) error = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  void setType(String? t) {
    type = t;
    notifyListeners();
  }
}