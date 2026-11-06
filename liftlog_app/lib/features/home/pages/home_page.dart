// features/home/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final name = context.watch<AuthProvider>().user?.name;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BERANDA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: Center(
        child: Text(name == null ? 'Halo!' : 'Halo, $name!',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
    );
  }
}