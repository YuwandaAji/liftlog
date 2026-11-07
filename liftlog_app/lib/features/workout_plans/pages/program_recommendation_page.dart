import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../auth/auth_provider.dart';
import '../models/program_template.dart';
import '../workout_plan_provider.dart';
import '../workout_plan_repository.dart';
import 'program_picker_page.dart';

const _weekdayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];

class ProgramRecommendationPage extends StatelessWidget {
  const ProgramRecommendationPage({super.key, required this.weekdays});

  /// Hari latihan yang dipilih di onboarding (Senin = 1).
  final List<int> weekdays;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (c) =>
            WorkoutPlanProvider(WorkoutPlanRepository(c.read<ApiClient>()))..loadRecommendation(),
        child: _View(weekdays: weekdays),
      );
}

class _View extends StatelessWidget {
  const _View({required this.weekdays});
  final List<int> weekdays;

  Future<void> _apply(BuildContext context) async {
    final ok = await context.read<WorkoutPlanProvider>().apply(weekdays);
    if (!ok || !context.mounted) return;
    await context.read<AuthProvider>().refreshStatus();
    if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }

  Future<void> _pickOther(BuildContext context) async {
    final p = context.read<WorkoutPlanProvider>();
    if (!await p.loadTemplates() || !context.mounted) return;
    final chosen = await Navigator.of(context).push<ProgramTemplate>(
      MaterialPageRoute(
        builder: (_) => ProgramPickerPage(templates: p.templates, currentId: p.selected?.id),
      ),
    );
    if (chosen != null) p.select(chosen);
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<WorkoutPlanProvider>();
    final t = p.selected;

    final Widget body;
    if (p.loading) {
      body = const Center(child: CircularProgressIndicator(color: AppColors.lime));
    } else if (t == null) {
      body = _LoadError(
        message: p.error ?? 'Gagal memuat rekomendasi.',
        onRetry: () => p.loadRecommendation(),
      );
    } else {
      body = SingleChildScrollView(
        child: _Content(
          t: t,
          match: p.match,
          weekdays: weekdays,
          error: p.error,
          applying: p.applying,
          loadingList: p.loadingList,
          onApply: () => _apply(context),
          onPick: () => _pickOther(context),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text('LIFTLOG',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24)),
          ],
        ),
      );
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.danger)),
            const SizedBox(height: 20),
            AppButton(label: 'COBA LAGI', onPressed: onRetry),
          ],
        ),
      );
}

String? _matchNote(String? match) => switch (match) {
      'level_days' =>
        'Program untuk tujuanmu belum tersedia, jadi ditampilkan program dengan level yang sama.',
      'lower_level_days' =>
        'Program levelmu untuk jumlah hari ini belum tersedia, jadi ditampilkan program satu level di bawahnya.',
      'beginner_days' || 'beginner_nearest' =>
        'Program untuk levelmu belum tersedia, jadi ditampilkan program pemula.',
      _ => null,
    };

class _Content extends StatelessWidget {
  const _Content({
    required this.t,
    required this.match,
    required this.weekdays,
    required this.error,
    required this.applying,
    required this.loadingList,
    required this.onApply,
    required this.onPick,
  });

  final ProgramTemplate t;
  final String? match;
  final List<int> weekdays;
  final String? error;
  final bool applying;
  final bool loadingList;
  final VoidCallback onApply;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final sorted = [...weekdays]..sort();
    final used = math.min(t.days, sorted.length);
    final usedDays = sorted.take(used).toList();
    final rest = [
      for (var d = 1; d <= 7; d++)
        if (!usedDays.contains(d)) _weekdayNames[d - 1],
    ];
    final note = _matchNote(match);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                        const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    match == 'chosen' ? 'PROGRAM PILIHANMU' : 'REKOMENDASI UNTUKMU',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: AppColors.lime,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(t.name.toUpperCase(), style: text.displayMedium?.copyWith(fontSize: 40)),
          const SizedBox(height: 8),
          Text(
            'Tujuan: ${goalLabel(t.goal)} · Level ${levelLabel(t.level)} · ${t.days} hari / minggu',
            style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoChip(icon: Icons.calendar_today_outlined, label: '$used SESI / MINGGU'),
              _InfoChip(
                  icon: Icons.timer_outlined, label: '~${t.estimatedMinutes} MNT / SESI'),
              _InfoChip(
                  icon: Icons.fitness_center, label: t.equipmentLabel().toUpperCase()),
            ],
          ),
          if (note != null) ...[
            const SizedBox(height: 12),
            Text(note,
                style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textSecondary)),
          ],
          if (t.days != sorted.length) ...[
            const SizedBox(height: 8),
            Text(
              'Program ini untuk ${t.days} hari, sedangkan kamu memilih ${sorted.length} hari.',
              style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textSecondary),
            ),
          ],
          const SizedBox(height: 20),
          const _MethodCard(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('JADWAL LATIHAN MINGGUAN',
                          style: text.titleLarge?.copyWith(fontSize: 22)),
                    ),
                    const Icon(Icons.swap_horiz, color: AppColors.lime),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('Urutan gerakan tiap sesi latihan.',
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 14),
                for (var i = 0; i < used; i++) ...[
                  _DayCard(
                    dayNumber: i + 1,
                    weekdayName: _weekdayNames[usedDays[i] - 1],
                    items: t.itemsOfDay(i + 1),
                  ),
                  if (i < used - 1) const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1B1E10),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF4A5A12)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle_outline, color: AppColors.lime),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TARGET AWAL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                            color: AppColors.lime,
                          )),
                      SizedBox(height: 4),
                      Text('Bangun konsistensi dan teknik form',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      SizedBox(height: 6),
                      Text(
                        'Target rep atau beban naik bertahap bila skor form ≥ 80% '
                        'dan target tercapai 2 sesi berturut-turut.',
                        style: TextStyle(fontSize: 13, height: 1.45, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (rest.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bed_outlined, size: 20, color: Colors.white70),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Hari istirahat: ${rest.join(', ')}',
                        style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  ),
                ],
              ),
            ),
          ],
          if (error != null) ...[
            const SizedBox(height: 16),
            Text(error!, style: const TextStyle(color: AppColors.danger)),
          ],
          const SizedBox(height: 24),
          AppButton(label: 'PAKAI PROGRAM INI  →', loading: applying, onPressed: onApply),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: (applying || loadingList) ? null : onPick,
            icon: loadingList
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
                  )
                : const Icon(Icons.tune, size: 20),
            label: const Text('PILIH PROGRAM LAIN'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              foregroundColor: Colors.white,
              backgroundColor: AppColors.surfaceHigh,
              side: const BorderSide(color: AppColors.border),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Kamu dapat mengubah program kapan saja di halaman Rencana latihan.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, height: 1.4, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white70),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                )),
          ],
        ),
      );
}

class _MethodCard extends StatelessWidget {
  const _MethodCard();

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: SizedBox(
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/for_you.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const ColoredBox(color: AppColors.surfaceHigh),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x44000000), Color(0xDD000000)],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SISTEM METODOLOGI',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4,
                          color: AppColors.lime,
                        )),
                    const SizedBox(height: 4),
                    Text('PROGRESSIVE OVERLOAD DASAR',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22)),
                    const SizedBox(height: 4),
                    const Text(
                      'Beban dan repetisi naik bertahap mengikuti hasil latihanmu.',
                      style: TextStyle(fontSize: 13, height: 1.4, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.dayNumber,
    required this.weekdayName,
    required this.items,
  });

  final int dayNumber;
  final String weekdayName;
  final List<ProgramTemplateItem> items;

  @override
  Widget build(BuildContext context) {
    final names = <String>{...items.map((i) => i.exerciseName)}.join(', ');
    final minutes = ProgramTemplate.minutesForSets(items.fold(0, (s, i) => s + i.targetSets));
    final cam = cameraLabel(items);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF262628),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3C),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('HARI $dayNumber · ${weekdayName.toUpperCase()}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                    )),
              ),
              const Spacer(),
              Text('${items.length} gerakan · ~$minutes mnt',
                  style: const TextStyle(fontSize: 12, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 10),
          Text(dayTitle(items),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
          const SizedBox(height: 6),
          Text(names,
              style: const TextStyle(fontSize: 14, height: 1.4, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              if (cam.isNotEmpty) _Badge(icon: Icons.videocam_outlined, label: cam),
              const Spacer(),
              Text(equipmentOf(items, short: true).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.lime),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                )),
          ],
        ),
      );
}