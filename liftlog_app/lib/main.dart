// main.dart
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/api_client.dart';
import 'core/token_storage.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/auth_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final tokens = TokenStorage();
  final api = ApiClient(tokens);
  final auth = AuthProvider(AuthRepository(api, tokens));
  api.onUnauthorized = auth.expire;
  runApp(App(tokens: tokens, api: api, auth: auth));
}