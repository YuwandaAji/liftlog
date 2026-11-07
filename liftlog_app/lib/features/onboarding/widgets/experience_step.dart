import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../onboarding_provider.dart';
import 'option_card.dart';
import 'step_parts.dart';

class ExperienceStep extends StatelessWidget {
  const ExperienceStep({super.key});

  // Urutan = nilai `experience` 0..2
  static const _options = [
    ('BELUM PERNAH', 'Baru memulai dan belum terbiasa dengan pola gerakan dasar latihan.'),
    ('KURANG DARI 6 BULAN',
        'Mulai rutin berlatih mandiri dengan teknik dan formasi dasar yang terstruktur.'),
    ('LEBIH DARI 6 BULAN',
        'Sudah terbiasa dengan variasi beban tubuh, dumbbell, serta progresi beban teratur.'),
  ];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<OnboardingProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StepHeading(
            title: 'PENGALAMAN BERLATIH',
            subtitle: 'Sudah berapa lama kamu berlatih beban secara teratur?',
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < _options.length; i++) ...[
            OptionCard(
              title: _options[i].$1,
              description: _options[i].$2,
              selected: p.experience == i,
              onTap: () => p.setExperience(i),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 4),
          const InfoNote(
            icon: Icons.tune,
            text: 'Level awal programmu ditentukan dari pengalaman dan frekuensi latihanmu.',
          ),
        ],
      ),
    );
  }
}