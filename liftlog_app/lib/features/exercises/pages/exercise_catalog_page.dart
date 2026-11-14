import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../exercise_provider.dart';
import '../exercise_repository.dart';
import '../widgets/exercise_card.dart';
import '../widgets/exercise_filter.dart';
import 'exercise_detail_page.dart';

class ExerciseCatalogPage extends StatelessWidget {
  const ExerciseCatalogPage({super.key, required this.onOpenProfile});

  /// Pindah ke tab Profil.
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => ExerciseProvider(ExerciseRepository(c.read<ApiClient>()))..load(),
        child: _View(onOpenProfile: onOpenProfile),
      );
}

class _View extends StatelessWidget {
  const _View({required this.onOpenProfile});
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ExerciseProvider>();
    final text = Theme.of(context).textTheme;

    final Widget body;
    if (p.loading && p.all.isEmpty) {
      body = const Center(child: CircularProgressIndicator(color: AppColors.lime));
    } else if (p.all.isEmpty) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(p.error ?? 'Belum ada gerakan.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.danger)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => p.load(), child: const Text('COBA LAGI')),
            ],
          ),
        ),
      );
    } else {
      final list = p.filtered;
      body = RefreshIndicator(
        color: AppColors.lime,
        backgroundColor: AppColors.surfaceHigh,
        onRefresh: () => p.load(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Row(
              children: [
                Text('LIFTLOG',
                    style: text.displayMedium?.copyWith(fontSize: 32, color: AppColors.lime)),
                const Spacer(),
                GestureDetector(
                  onTap: onOpenProfile,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceHigh,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.person_outline, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('KATALOG GERAKAN',
                style: text.titleLarge?.copyWith(fontSize: 32,)),
            const SizedBox(height: 4),
            Text('${p.all.length} gerakan untuk latihan di rumah',
                style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 16),
            ExerciseFilter(
              selected: p.type,
              allCount: p.count(null),
              bodyweightCount: p.count('bodyweight'),
              dumbbellCount: p.count('dumbbell'),
              onChanged: p.setType,
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 244,
              ),
              itemBuilder: (context, i) => ExerciseCard(
                exercise: list[i],
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ExerciseDetailPage(exercise: list[i])),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SafeArea(bottom: false, child: body);
  }
}