import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class OptionCard extends StatelessWidget {
  const OptionCard({
    super.key,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
    this.index,
    this.limeTitle = false,
    this.titleSize = 22,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;
  final String? index;
  final bool limeTitle; // judul jadi lime saat terpilih (dipakai di Data tubuh)
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF26281A) : AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.lime : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (index != null) ...[
                        Text(
                          index!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: selected ? AppColors.lime : Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          title,
                          style: head.copyWith(
                            fontSize: titleSize,
                            color: selected && limeTitle ? AppColors.lime : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(description,
                      style: const TextStyle(fontSize: 14, height: 1.45, color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.lime : const Color(0xFF3A3A3C),
              ),
              child: selected ? const Icon(Icons.check, size: 18, color: Colors.black) : null,
            ),
          ],
        ),
      ),
    );
  }
}