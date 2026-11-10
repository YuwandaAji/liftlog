import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../../shared/widgets/personal_record_card.dart';
import '../../auth/auth_provider.dart';
import '../../history/history_repository.dart';
import '../../profile/profile_repository.dart';
import '../../workout_plans/models/workout_plan.dart';
import '../../workout_plans/workout_plan_repository.dart';
import '../home_provider.dart';
import '../widgets/today_workout_card.dart';
import '../widgets/weekly_summary_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.onFreeWorkout, required this.onOpenProfile});

  /// Pindah ke tab Latihan (katalog) untuk latihan bebas.
  final VoidCallback onFreeWorkout;

  /// Pindah ke tab Profil.
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) {
          final api = c.read<ApiClient>();
          return HomeProvider(
            plans: WorkoutPlanRepository(api),
            profiles: ProfileRepository(api),
            history: HistoryRepository(api),
          )..load();
        },
        child: _HomeView(onFreeWorkout: onFreeWorkout, onOpenProfile: onOpenProfile),
      );
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.onFreeWorkout, required this.onOpenProfile});
  final VoidCallback onFreeWorkout;
  final VoidCallback onOpenProfile;

  void _soon(BuildContext context, String what) => ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('$what belum tersedia.')));

  @override
  Widget build(BuildContext context) {
    final p = context.watch<HomeProvider>();
    final today = p.today;

    final Widget body;
    if (p.loading && today == null) {
      body = const Center(child: CircularProgressIndicator(color: AppColors.lime));
    } else if (today == null) {
      body = _LoadError(message: p.error ?? 'Gagal memuat Beranda.', onRetry: () => p.load());
    } else {
      body = RefreshIndicator(
        color: AppColors.lime,
        backgroundColor: AppColors.surfaceHigh,
        onRefresh: () => p.load(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            _Header(onOpenProfile: onOpenProfile),
            const SizedBox(height: 16),
            _Greeting(streakDays: p.stats?.streakDays ?? 0),
            if (today.session != null) ...[
              const SizedBox(height: 14),
              _WeekStrip(
                today: today,
                doneWeekdays: p.stats?.doneWeekdays ?? const [],
              ),
            ],
            const SizedBox(height: 16),
            TodayWorkoutCard(
              today: today,
              onStart: () => _soon(context, 'Sesi latihan'),
              onFreeWorkout: onFreeWorkout,
              onOpenSession: (_) => _soon(context, 'Detail sesi'),
            ),
            const SizedBox(height: 20),
            WeeklySummaryCard(
              stats: p.stats,
              fallbackTarget: today.plan?.daysPerWeek ?? today.schedules.length,
            ),
            if (p.record != null && p.record!.isRecent) ...[
              const SizedBox(height: 16),
              PersonalRecordCard(record: p.record!),
            ],
            if (p.needs != null) ...[
              const SizedBox(height: 16),
              _NeedsCard(tdee: p.needs!.tdee, protein: p.needs!.proteinGrams),
            ],
          ],
        ),
      );
    }

    return SafeArea(bottom: false, child: body);
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.danger)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onRetry, child: const Text('COBA LAGI')),
            ],
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header({required this.onOpenProfile});
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            'LIFTLOG',
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontSize: 32, color: AppColors.lime),
          ),
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
      );
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.streakDays});
  final int streakDays;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final name = context.watch<AuthProvider>().user?.name.trim().split(' ').first;
    final head = Theme.of(context).textTheme.titleLarge!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${kWeekdayNames[now.weekday - 1]}, ${now.day} ${kMonthNames[now.month - 1]}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                (name == null || name.isEmpty) ? 'HALO' : 'HALO, ${name.toUpperCase()}',
                style: head.copyWith(fontSize: 32),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department, size: 18, color: AppColors.lime),
              const SizedBox(width: 6),
              Text('$streakDays', style: head.copyWith(fontSize: 18)),
              const SizedBox(width: 4),
              const Text('HARI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: Colors.white70,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekStrip extends StatelessWidget {
  const _WeekStrip({required this.today, required this.doneWeekdays});
  final TodayWorkout today;
  final List<int> doneWeekdays;

  @override
  Widget build(BuildContext context) {
    final scheduled = today.schedules.map((s) => s.weekday).toSet();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          for (var d = 1; d <= 7; d++)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: d == today.weekday ? AppColors.lime : Colors.transparent,
                  ),
                ),
                child: Column(
                  children: [
                    Text(kWeekdayShort[d - 1],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: (scheduled.contains(d) || d == today.weekday)
                              ? Colors.white
                              : AppColors.textSecondary,
                        )),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 20,
                      child: Center(
                        child: doneWeekdays.contains(d)
                            ? const Icon(Icons.check_circle_outline,
                                size: 20, color: AppColors.lime)
                            : scheduled.contains(d)
                                ? Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                        color: AppColors.lime, shape: BoxShape.circle),
                                  )
                                : const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NeedsCard extends StatelessWidget {
  const _NeedsCard({required this.tdee, required this.protein});
  final int tdee;
  final int protein;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('KEBUTUHAN HARIAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.4,
                color: Colors.white70,
              )),
          const SizedBox(height: 8),
          Text('PERKIRAAN KEBUTUHAN HARIANMU', style: head.copyWith(fontSize: 22)),
          const SizedBox(height: 6),
          const Text(
            'Dihitung dengan rumus dari data tubuhmu. Ini perkiraan, bukan saran medis.',
            style: TextStyle(fontSize: 13, height: 1.45, color: Colors.white70),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _NeedTile(label: 'ENERGI (TDEE)', value: formatThousands(tdee), unit: 'KKAL')),
              const SizedBox(width: 10),
              Expanded(child: _NeedTile(label: 'PROTEIN', value: '$protein', unit: 'G')),
            ],
          ),
          const SizedBox(height: 12),
          const Text('DIHITUNG DARI DATA TUBUHMU',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.textSecondary,
              )),
        ],
      ),
    );
  }
}

class _NeedTile extends StatelessWidget {
  const _NeedTile({required this.label, required this.value, required this.unit});
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: AppColors.textSecondary,
              )),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: head.copyWith(fontSize: 28)),
              const SizedBox(width: 4),
              Text(unit, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}