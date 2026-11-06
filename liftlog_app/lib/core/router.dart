// core/router.dart
import 'package:flutter/material.dart';
import '../features/auth/pages/register_page.dart';

class AppRoutes {
  static const register = '/register';
}

final Map<String, WidgetBuilder> appRoutes = {
  AppRoutes.register: (_) => const RegisterPage(),
};