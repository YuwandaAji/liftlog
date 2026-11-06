import '../../core/api_client.dart';
import '../../core/token_storage.dart';
import 'models/user.dart';

class AuthRepository {
  AuthRepository(this._api, this._tokens);
  final ApiClient _api;
  final TokenStorage _tokens;

  Future<bool> hasToken() async => (await _tokens.read()) != null;
  Future<void> clearToken() => _tokens.clear();

  Future<User> login(String email, String password) async {
    final res = await _api.post('/login', data: {'email': email, 'password': password});
    await _tokens.save(res['token']);
    return User.fromJson(res['user']);
  }

  Future<User> register(String name, String email, String password, String confirm) async {
    final res = await _api.post('/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': confirm,
    });
    await _tokens.save(res['token']);
    return User.fromJson(res['user']);
  }

  Future<void> logout() async {
    try {
      await _api.post('/logout');
    } catch (_) {
      // abaikan: token lokal tetap dihapus
    }
    await _tokens.clear();
  }

  /// true bila onboarding sudah selesai (profile.level terisi).
  /// Mendukung dua bentuk respons GET /profile: {profile: {...}} atau langsung {...}.
  Future<bool> isOnboarded() async {
    final data = await _api.get('/profile');
    final profile = (data is Map && data['profile'] is Map) ? data['profile'] : data;
    return profile is Map && profile['level'] != null;
  }
}