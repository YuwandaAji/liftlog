import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/history/models/personal_record.dart';

class PersonalRecordCard extends StatelessWidget {
  const PersonalRecordCard({super.key, required this.record});
  final PersonalRecord record;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    final delta = record.deltaLabel;

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
          Row(
            children: [
              const Text('REKOR BARU',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.4,
                    color: Colors.white70,
                  )),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3C),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('PERSONAL BEST',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(color: Color(0xFF2A3010), shape: BoxShape.circle),
                child: const Icon(Icons.emoji_events_outlined, color: AppColors.lime),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record.exerciseName.toUpperCase(), style: head.copyWith(fontSize: 20)),
                    const SizedBox(height: 2),
                    Text('${record.whenLabel} · PRIBADI TERBAIK',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: AppColors.textSecondary,
                        )),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${record.valueLabel} ${record.unit}',
                      style: head.copyWith(fontSize: 26, color: AppColors.lime)),
                  if (delta != null)
                    Text(delta,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: Colors.white70,
                        )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}