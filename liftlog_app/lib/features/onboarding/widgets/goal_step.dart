import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../onboarding_provider.dart';
import 'option_card.dart';
import 'step_parts.dart';

class GoalStep extends StatelessWidget {
  const GoalStep({super.key});

  static const _options = [
    ('muscle', 'MENGUATKAN OTOT',
        'Fokus pada peningkatan daya tahan otot dan hipertrofi dengan beban tubuh & dumbbell.'),
    ('stamina', 'STAMINA',
        'Meningkatkan daya tahan kardiorespirasi dan kapasitas kerja fisik intensif.'),
    ('general', 'BENTUK TUBUH UMUM',
        'Menjaga kebugaran dan mobilitas harian secara seimbang.'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<OnboardingProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StepHeading(title: 'TUJUAN BERLATIH', subtitle: 'Untuk apa kamu berlatih?'),
          const SizedBox(height: 20),
          const _GoalHero(),
          const SizedBox(height: 20),
          for (var i = 0; i < _options.length; i++) ...[
            OptionCard(
              index: '0${i + 1}',
              title: _options[i].$2,
              description: _options[i].$3,
              selected: p.goal == _options[i].$1,
              onTap: () => p.setGoal(_options[i].$1),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          const InfoNote(
            icon: Icons.tune,
            text: 'Program latihan harian akan disesuaikan dengan tujuan utamamu.',
          ),
        ],
      ),
    );
  }
}

class _GoalHero extends StatelessWidget {
  const _GoalHero();

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 140,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/onboarding_image.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const ColoredBox(color: AppColors.surfaceHigh),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x33000000), Color(0xCC000000)],
                  ),
                ),
              ),
              const Positioned(
                left: 16,
                bottom: 14,
                child: Text(
                  'BEBAN TUBUH & DUMBBELL',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}