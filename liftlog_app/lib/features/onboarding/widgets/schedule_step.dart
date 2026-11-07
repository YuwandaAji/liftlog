import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../onboarding_provider.dart';
import 'option_card.dart';
import 'step_parts.dart';

class ScheduleStep extends StatelessWidget {
  const ScheduleStep({super.key});

  // Urutan = nilai `frequency` 0..2
  static const _frequencies = [
    ('0X PER MINGGU', 'Belum rutin berolahraga'),
    ('1–2X PER MINGGU', 'Sedang aktif bergerak'),
    ('3X+ PER MINGGU', 'Rutin dan disiplin'),
  ];
  static const _short = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB', 'MIN'];
  static const _full = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

  @override
  Widget build(BuildContext context) {
    final p = context.watch<OnboardingProvider>();
    final days = p.sortedWeekdays;
    final ok = days.length >= 2 && days.length <= 4;
    final status = days.isEmpty
        ? 'Pilih 2–4 hari latihan.'
        : days.length < 2
            ? 'Pilih minimal 2 hari.'
            : days.length > 4
                ? 'Maksimal 4 hari (terpilih ${days.length}).'
                : 'Terpilih ${days.length} hari: ${days.map((d) => _full[d - 1]).join(', ')}';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StepHeading(
            title: 'FREKUENSI & HARI',
            subtitle: 'Seberapa sering kamu berlatih dan berapa hari yang tersedia?',
          ),
          const SizedBox(height: 24),
          const SectionLabel('01 / FREKUENSI LATIHAN SEKARANG'),
          const SizedBox(height: 12),
          for (var i = 0; i < _frequencies.length; i++) ...[
            OptionCard(
              title: _frequencies[i].$1,
              description: _frequencies[i].$2,
              titleSize: 20,
              selected: p.frequency == i,
              onTap: () => p.setFrequency(i),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 14),
          const SectionLabel('02 / PILIH HARI LATIHAN'),
          const SizedBox(height: 6),
          const Text('Pilih 2–4 hari dalam seminggu.',
              style: TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 12),
          Row(
            children: [
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: i == 0 ? 0 : 6),
                    child: _DayChip(
                      label: _short[i],
                      selected: p.weekdays.contains(i + 1),
                      onTap: () => p.toggleWeekday(i + 1),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ok ? AppColors.lime : AppColors.danger,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(status,
                    style: TextStyle(
                        fontSize: 13, color: ok ? Colors.white70 : AppColors.danger)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const InfoNote(
            icon: Icons.tune,
            text: 'Hari latihan bisa diubah nanti di Rencana latihan.',
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.lime : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 15,
                  color: selected ? Colors.black : Colors.white70,
                ),
          ),
        ),
      );
}