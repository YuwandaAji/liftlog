import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../onboarding_provider.dart';
import 'option_card.dart';
import 'step_parts.dart';

class BodyDataStep extends StatefulWidget {
  const BodyDataStep({super.key});
  @override
  State<BodyDataStep> createState() => _BodyDataStepState();
}

class _BodyDataStepState extends State<BodyDataStep> {
  late final TextEditingController _weight;
  late final TextEditingController _height;
  late final TextEditingController _age;

  // Nilai `activity_level` yang dikirim ke API
  static const _activities = [
    ('sedentary', 'SEDENTARI', 'Jarang beraktivitas atau olahraga.'),
    ('light', 'RINGAN', 'Aktivitas ringan atau olahraga 1–3 hari/minggu.'),
    ('moderate', 'SEDANG', 'Olahraga 3–5 hari/minggu.'),
    ('active', 'TINGGI', 'Olahraga berat atau aktivitas fisik intensif.'),
  ];

  @override
  void initState() {
    super.initState();
    final p = context.read<OnboardingProvider>();
    _weight = TextEditingController(text: p.weightText);
    _height = TextEditingController(text: p.heightText);
    _age = TextEditingController(text: p.ageText);
  }

  @override
  void dispose() {
    _weight.dispose();
    _height.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<OnboardingProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const StepHeading(
            title: 'DATA TUBUH',
            subtitle: 'Lengkapi informasi tubuhmu untuk menghitung kebutuhan harian.',
          ),
          const SizedBox(height: 24),
          const SectionLabel('01 / METRIK DASAR', trailing: 'TELEMETRI AWAL'),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MetricField(
                  label: 'Berat badan',
                  hint: 'Contoh: 60',
                  unit: 'kg',
                  controller: _weight,
                  decimal: true,
                  onChanged: p.setWeight,
                  validator: Validators.number('Berat badan',
                      OnboardingProvider.minWeight, OnboardingProvider.maxWeight),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricField(
                  label: 'Tinggi badan',
                  hint: 'Contoh: 170',
                  unit: 'cm',
                  controller: _height,
                  decimal: true,
                  onChanged: p.setHeight,
                  validator: Validators.number('Tinggi badan',
                      OnboardingProvider.minHeight, OnboardingProvider.maxHeight),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _MetricField(
            label: 'Usia',
            hint: 'Contoh: 20',
            unit: 'tahun',
            controller: _age,
            onChanged: p.setAge,
            validator:
                Validators.number('Usia', OnboardingProvider.minAge, OnboardingProvider.maxAge),
          ),
          const SizedBox(height: 24),
          const SectionLabel('02 / JENIS KELAMIN'),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: OptionCard(
                    title: 'LAKI-LAKI',
                    description: 'Untuk rumus BMR',
                    titleSize: 18,
                    limeTitle: true,
                    selected: p.gender == 'male',
                    onTap: () => p.setGender('male'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OptionCard(
                    title: 'PEREMPUAN',
                    description: 'Untuk rumus BMR',
                    titleSize: 18,
                    limeTitle: true,
                    selected: p.gender == 'female',
                    onTap: () => p.setGender('female'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionLabel('03 / TINGKAT AKTIVITAS'),
          const SizedBox(height: 12),
          for (final a in _activities) ...[
            OptionCard(
              title: a.$2,
              description: a.$3,
              limeTitle: true,
              selected: p.activityLevel == a.$1,
              onTap: () => p.setActivityLevel(a.$1),
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 6),
          const InfoNote(
            icon: Icons.calculate_outlined,
            text: 'Dipakai untuk memperkirakan BMR, TDEE, dan protein harian dengan rumus. '
                'Ini perkiraan, bukan saran medis.',
          ),
        ],
      ),
    );
  }
}

class _MetricField extends StatelessWidget {
  const _MetricField({
    required this.label,
    required this.hint,
    required this.unit,
    required this.controller,
    required this.onChanged,
    required this.validator,
    this.decimal = false,
  });

  final String label;
  final String hint;
  final String unit;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? Function(String?) validator;
  final bool decimal;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
                color: Colors.white70,
              ),
            ),
            TextFormField(
              controller: controller,
              onChanged: onChanged,
              validator: validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.numberWithOptions(decimal: decimal),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(decimal ? r'[0-9.,]' : r'[0-9]')),
              ],
              style: const TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.only(top: 10, bottom: 4),
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                suffixText: unit,
                suffixStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.white70,
                ),
                errorStyle: const TextStyle(fontSize: 12, color: AppColors.danger),
              ),
            ),
          ],
        ),
      );
}