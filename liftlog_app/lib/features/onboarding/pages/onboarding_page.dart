import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../auth/auth_provider.dart';
import '../../profile/profile_repository.dart';
import '../onboarding_provider.dart';
import '../widgets/body_data_step.dart';
import '../widgets/experience_step.dart';
import '../widgets/goal_step.dart';
import '../widgets/schedule_step.dart';
import '../../workout_plans/pages/program_recommendation_page.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) => OnboardingProvider(ProfileRepository(c.read<ApiClient>())),
        child: const _OnboardingView(),
      );
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView();

  static const _steps = <Widget>[GoalStep(), ExperienceStep(), ScheduleStep(), BodyDataStep()];

    Future<void> _onPrimary(BuildContext context) async {
    final p = context.read<OnboardingProvider>();
    if (!p.isLast) {
      p.next();
      return;
    }
    final ok = await p.submit();
    if (ok && context.mounted) {
      // refreshStatus() dipanggil di halaman Program untukmu, setelah rencana dibuat.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ProgramRecommendationPage(weekdays: p.sortedWeekdays),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<OnboardingProvider>();

    return PopScope(
      canPop: p.step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) p.back();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              _Header(step: p.step),
              Expanded(
                child: SingleChildScrollView(
                  key: ValueKey(p.step),
                  child: _steps[p.step],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (p.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(p.error!, style: const TextStyle(color: AppColors.danger)),
                      ),
                    AppButton(
                      label: p.isLast ? 'SELESAI' : 'LANJUT',
                      loading: p.loading,
                      onPressed: p.canProceed ? () => _onPrimary(context) : null,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'TUJUAN, PENGALAMAN, FREKUENSI & HARI, DATA TUBUH',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.step});
  final int step;

  static const _labels = ['TUJUAN', 'PENGALAMAN', 'FREKUENSI', 'PROFIL'];

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    const small = TextStyle(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text('LIFTLOG', style: head.copyWith(fontSize: 24)),
              const Spacer(),
              Text(
                'LANGKAH ${(step + 1).toString().padLeft(2, '0')} / 04',
                style: small.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (var i = 0; i < _labels.length; i++)
                Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
                    decoration: BoxDecoration(
                      color: i <= step ? AppColors.lime : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                style: small.copyWith(color: Colors.white70),
                children: [
                  for (var i = 0; i < _labels.length; i++) ...[
                    TextSpan(
                      text: _labels[i],
                      style: i == step ? const TextStyle(color: AppColors.lime) : null,
                    ),
                    if (i < _labels.length - 1) const TextSpan(text: '  •  '),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}