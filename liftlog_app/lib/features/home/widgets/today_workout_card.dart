import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/format.dart';
import '../../workout_plans/models/program_template.dart' show ProgramTemplate;
import '../../workout_plans/models/workout_plan.dart';

BoxDecoration _cardDeco() => BoxDecoration(
      color: AppColors.surfaceHigh,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.border),
    );

class TodayWorkoutCard extends StatelessWidget {
  const TodayWorkoutCard({
    super.key,
    required this.today,
    required this.onStart,
    required this.onFreeWorkout,
    required this.onOpenSession,
  });

  final TodayWorkout today;
  final VoidCallback onStart;
  final VoidCallback onFreeWorkout;
  final void Function(int sessionId) onOpenSession;

  @override
  Widget build(BuildContext context) {
    final s = today.session;
    if (s != null) return _DoneCard(today: today, session: s, onOpen: () => onOpenSession(s.id));
    if (today.scheduled) return _ScheduledCard(today: today, onStart: onStart);
    return _RestCard(onFreeWorkout: onFreeWorkout);
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.3,
                color: AppColors.lime,
              ),
            ),
          ),
        ],
      );
}

// ---------------------------------------------------------------- terjadwal

class _ScheduledCard extends StatelessWidget {
  const _ScheduledCard({required this.today, required this.onStart});
  final TodayWorkout today;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    final items = today.items;
    final minutes = ProgramTemplate.minutesForSets(items.fold(0, (s, i) => s + i.targetSets));
    final dayName = kWeekdayNames[today.weekday - 1];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(child: _Eyebrow('$dayName · HARI ${today.dayNumber}')),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text('TERJADWAL',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: Colors.white70,
                    )),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('LATIHAN HARI INI', style: head.copyWith(fontSize: 28)),
          const SizedBox(height: 4),
          Text('~$minutes menit · ${items.length} gerakan',
              style: const TextStyle(fontSize: 14, color: Colors.white70)),
          const SizedBox(height: 14),
          for (final item in items) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.exerciseName.toUpperCase(), style: head.copyWith(fontSize: 18)),
                        if (item.cameraText.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.videocam_outlined, size: 14, color: AppColors.lime),
                              const SizedBox(width: 6),
                              Text('KAMERA: ${item.cameraText}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                    color: AppColors.textSecondary,
                                  )),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(item.targetLabel,
                      style: head.copyWith(fontSize: 22, color: AppColors.lime)),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('MULAI SESI LATIHAN'),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ istirahat

class _RestCard extends StatelessWidget {
  const _RestCard({required this.onFreeWorkout});
  final VoidCallback onFreeWorkout;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;

    return Container(
      decoration: _cardDeco(),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 130,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  'assets/images/home_rest.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) =>
                      const ColoredBox(color: AppColors.surface),
                ),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x66000000), Color(0xEE1C1C1E)],
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xCC1C1C1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('HARI ISTIRAHAT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        )),
                  ),
                ),
                const Positioned(
                  right: 14,
                  top: 14,
                  child: Icon(Icons.nightlight_outlined, color: Colors.white70),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Eyebrow('PEMULIHAN OTOT'),
                const SizedBox(height: 10),
                Text('TIDAK ADA LATIHAN TERJADWAL HARI INI', style: head.copyWith(fontSize: 26)),
                const SizedBox(height: 8),
                const Text(
                  'Pemulihan otot dan hidrasi yang cukup membantu sesi berikutnya.',
                  style: TextStyle(fontSize: 14, height: 1.45, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: onFreeWorkout,
                  icon: const Icon(Icons.open_in_new, size: 18),
                  label: const Text('LATIHAN BEBAS'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.border),
                    shape: const StadiumBorder(),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ sudah latihan

class _DoneCard extends StatelessWidget {
  const _DoneCard({required this.today, required this.session, required this.onOpen});
  final TodayWorkout today;
  final TodaySession session;
  final VoidCallback onOpen;

  String? _time() {
    final t = session.endedAt;
    if (t == null) return null;
    final hhmm = '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    final zone = t.timeZoneName;
    final okZone = zone.isNotEmpty && zone.length <= 5 && !zone.startsWith('+') && !zone.startsWith('-');
    return okZone ? '$hhmm $zone' : hhmm;
  }

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    final form = session.formScore;
    final pct = form == null ? null : (form * 100).round();
    final optimal = (form ?? 0) >= 0.8;
    final time = _time();
    final subtitle = (today.scheduled && today.dayNumber != null)
        ? 'Sesi hari ke-${today.dayNumber} dari rencanamu sudah tercatat.'
        : 'Sesimu hari ini sudah tercatat.';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const _Eyebrow('SELESAI HARI INI'),
              const Spacer(),
              if (time != null)
                Text(time,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          Text('SUDAH LATIHAN HARI INI', style: head.copyWith(fontSize: 28)),
          const SizedBox(height: 6),
          Text(subtitle,
              style: const TextStyle(fontSize: 14, height: 1.45, color: Colors.white70)),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(optimal ? 'SKOR FORM OPTIMAL' : 'SKOR FORM',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Colors.white70,
                    )),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(pct == null ? '–' : '$pct%',
                        style: head.copyWith(fontSize: 56, color: AppColors.lime)),
                    const SizedBox(width: 8),
                    Text('AKURASI', style: head.copyWith(fontSize: 20)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: form?.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    color: AppColors.lime,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                        child: _MiniStat(label: 'VALID REP', value: '${session.validReps}', unit: 'REP')),
                    Expanded(
                        child: _MiniStat(label: 'DURASI', value: '${session.durationMinutes}', unit: 'MNT')),
                    Expanded(
                        child: _MiniStat(
                            label: 'VOL. BEBAN',
                            value: formatThousands(session.volumeKg),
                            unit: 'KG')),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onOpen,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: Colors.white,
              backgroundColor: AppColors.surface,
              side: const BorderSide(color: AppColors.border),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, letterSpacing: 1),
            ),
            child: const Text('LIHAT DETAIL SESI  ›'),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value, required this.unit});
  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: AppColors.textSecondary,
            )),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: head.copyWith(fontSize: 22)),
            const SizedBox(width: 3),
            Text(unit,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}