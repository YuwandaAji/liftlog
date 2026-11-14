import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/bottom_navigation_bar.dart';
import '../../auth/auth_provider.dart';
import 'home_page.dart';
import '../../exercises/pages/exercise_catalog_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      HomePage(
        onFreeWorkout: () => setState(() => _index = 1),
        onOpenProfile: () => setState(() => _index = 3),
      ),
      ExerciseCatalogPage(onOpenProfile: () => setState(() => _index = 3)),
      const _ComingSoon(title: 'AKTIVITAS'),
      const _ProfileStub(),
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _ComingSoon extends StatelessWidget {
  const _ComingSoon({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 36)),
              const SizedBox(height: 8),
              const Text('Segera hadir', style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
      );
}

class _ProfileStub extends StatelessWidget {
  const _ProfileStub();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('PROFIL', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 36)),
              const SizedBox(height: 8),
              const Text('Segera hadir', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.read<AuthProvider>().logout(),
                child: const Text('KELUAR'),
              ),
            ],
          ),
        ),
      );
}