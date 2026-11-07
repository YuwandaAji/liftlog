import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class StepHeading extends StatelessWidget {
  const StepHeading({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 34)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.white70)),
        ],
      );
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.trailing});
  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.6,
      color: Colors.white70,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: style),
        if (trailing != null)
          Text(trailing!, style: style.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class InfoNote extends StatelessWidget {
  const InfoNote({super.key, required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.lime, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, height: 1.45, color: Colors.white70)),
            ),
          ],
        ),
      );
}