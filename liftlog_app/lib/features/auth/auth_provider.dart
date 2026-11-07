import 'package:flutter/foundation.dart';
import '../../core/api_client.dart';
import 'auth_repository.dart';
import 'models/user.dart';

enum AuthStatus { unknown, unauthenticated, needsOnboarding, authenticated }

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repo);
  final AuthRepository _repo;

  AuthStatus status = AuthStatus.unknown;
  User? user;
  bool loading = false;
  String? error;

  Future<void> restore() async {
    if (!await _repo.hasToken()) {
      status = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    await _resolveStatus();
  }

  Future<bool> login(String email, String password) =>
      _run(() async => user = await _repo.login(email, password));

  Future<bool> register(String name, String email, String password, String confirm) =>
      _run(() async => user = await _repo.register(name, email, password, confirm));

  Future<void> logout() async {
    await _repo.logout();
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  /// Dipasang ke ApiClient.onUnauthorized (token ditolak server).
  Future<void> expire() async {
    await _repo.clearToken();
    user = null;
    status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<void> refreshStatus() => _resolveStatus();

  void clearError() {
    error = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await action();
      await _resolveStatus();
      return true;
    } on ApiException catch (e) {
      error = e.message;
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> _resolveStatus() async {
    try {
      status = await _repo.isOnboarded()
          ? AuthStatus.authenticated
          : AuthStatus.needsOnboarding;
    } on ApiException catch (e) {
      if (e.statusCode == 401) {
        await _repo.clearToken();
      } else {
        error = e.message;
      }
      status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }
}