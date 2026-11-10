import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/app_loading.dart';
import '../../home/pages/main_shell.dart';
import '../../onboarding/pages/onboarding_page.dart';
import '../auth_provider.dart';
import 'login_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<AuthProvider>().restore(),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (context.watch<AuthProvider>().status) {
      case AuthStatus.unknown:
        return const Scaffold(body: AppLoading());
      case AuthStatus.unauthenticated:
        return const LoginPage();
      case AuthStatus.needsOnboarding:
        return const OnboardingPage();
      case AuthStatus.authenticated:
        return const MainShell();
    }
  }
}