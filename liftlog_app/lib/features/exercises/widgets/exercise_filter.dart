import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ExerciseFilter extends StatelessWidget {
  const ExerciseFilter({
    super.key,
    required this.selected,
    required this.allCount,
    required this.bodyweightCount,
    required this.dumbbellCount,
    required this.onChanged,
  });

  final String? selected; // null | bodyweight | dumbbell
  final int allCount;
  final int bodyweightCount;
  final int dumbbellCount;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final chips = <(String?, String, int)>[
      (null, 'SEMUA', allCount),
      ('bodyweight', 'BODYWEIGHT', bodyweightCount),
      ('dumbbell', 'DUMBBELL', dumbbellCount),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final c in chips) ...[
            _Chip(
              label: c.$2,
              count: c.$3,
              selected: selected == c.$1,
              onTap: () => onChanged(c.$1),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? AppColors.lime : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: selected ? AppColors.lime : AppColors.border),
          ),
          child: Text(
            '$label ($count)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
              color: selected ? Colors.black : Colors.white70,
            ),
          ),
        ),
      );
}