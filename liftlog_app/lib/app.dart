// app.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api_client.dart';
import 'core/router.dart';
import 'core/theme/app_theme.dart';
import 'core/token_storage.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/pages/auth_gate.dart';

class App extends StatelessWidget {
  final TokenStorage tokens;
  final ApiClient api;
  final AuthProvider auth;
  const App({super.key, required this.tokens, required this.api, required this.auth});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          Provider<TokenStorage>.value(value: tokens),
          Provider<ApiClient>.value(value: api),
          ChangeNotifierProvider<AuthProvider>.value(value: auth),
        ],
        child: MaterialApp(
          title: 'LiftLog',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: const AuthGate(),
          routes: appRoutes,
        ),
      );
}