import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../history/models/weekly_stats.dart';

class WeeklySummaryCard extends StatelessWidget {
  const WeeklySummaryCard({super.key, required this.stats, required this.fallbackTarget});

  final WeeklyStats? stats;
  final int fallbackTarget; // dipakai bila statistik belum tersedia

  String _weekRange() {
    final now = DateTime.now();
    final mon = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final sun = mon.add(const Duration(days: 6));
    if (mon.month == sun.month) {
      return '${mon.day}–${sun.day} ${kMonthShort[sun.month - 1]}';
    }
    return '${mon.day} ${kMonthShort[mon.month - 1]}–${sun.day} ${kMonthShort[sun.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    final s = stats;
    final target = s?.sessionsTarget ?? fallbackTarget;
    final done = s?.sessionsDone ?? 0;
    final delta = s?.validRepsDelta;
    final form = s?.avgFormScore;
    final optimal = (form ?? 0) >= 0.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('RINGKASAN MINGGU INI', style: head.copyWith(fontSize: 20)),
            const Spacer(),
            Text(_weekRange(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.lime,
                )),
          ],
        ),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _Tile(
                  label: 'SESI',
                  value: s == null ? '–' : '$done',
                  valueSuffix: s == null && target == 0 ? null : '/$target',
                  footer: s == null ? null : (done >= target && target > 0 ? 'TERCAPAI' : 'TARGET MINGGUAN'),
                  footerColor: done >= target && target > 0 ? AppColors.lime : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Tile(
                  label: 'REP VALID',
                  value: s == null ? '–' : formatThousands(s.validReps),
                  footer: delta == null
                      ? null
                      : '${delta >= 0 ? '+' : '−'}${delta.abs()} DARI MINGGU LALU',
                  footerColor: (delta ?? 0) >= 0 ? AppColors.lime : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _Tile(
                  label: 'SKOR FORM',
                  value: form == null ? '–' : '${(form * 100).round()}%',
                  footer: form == null ? null : (optimal ? 'OPTIMAL' : 'BISA DITINGKATKAN'),
                  footerColor: optimal ? AppColors.lime : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.value,
    this.valueSuffix,
    this.footer,
    this.footerColor = AppColors.textSecondary,
  });

  final String label;
  final String value;
  final String? valueSuffix;
  final String? footer;
  final Color footerColor;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Colors.white70,
              )),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: head.copyWith(fontSize: 28)),
              if (valueSuffix != null)
                Text(valueSuffix!,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 4),
          Text(footer ?? ' ',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
                color: footerColor,
              )),
        ],
      ),
    );
  }
}