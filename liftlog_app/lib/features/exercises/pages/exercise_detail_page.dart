import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/exercise.dart';
import '../widgets/exercise_video.dart';

class ExerciseDetailPage extends StatelessWidget {
  const ExerciseDetailPage({super.key, required this.exercise});
  final Exercise exercise;

  String get _cameraTip => exercise.cameraPosition == 'front'
      ? 'Letakkan ponsel setinggi dada pada jarak sekitar 2–2,5 meter di depan tubuhmu '
          'agar kedua lengan terlihat jelas oleh kamera.'
      : 'Letakkan ponsel setinggi pinggul pada jarak sekitar 2–2,5 meter dari sisi samping '
          'tubuhmu agar sendi yang dilacak terlihat jelas oleh kamera.';

  @override
  Widget build(BuildContext context) {
    final head = Theme.of(context).textTheme.titleLarge!;
    final muscles = exercise.muscles;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('DETAIL GERAKAN'),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: ElevatedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kamera live belum tersedia.')),
            ),
            icon: const Icon(Icons.videocam_outlined),
            label: const Text('MULAI DENGAN KAMERA'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          ExerciseVideo(exercise: exercise),
          const SizedBox(height: 16),
          Text(exercise.name.toUpperCase(),
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 40)),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(exercise.typeLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: Colors.white70,
                    )),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.lime,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.videocam_outlined, size: 14, color: Colors.black),
                    const SizedBox(width: 4),
                    Text('KAMERA: ${exercise.cameraLabel.toUpperCase()}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: Colors.black,
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _InfoTile(
                    label: 'TARGET OTOT',
                    value: muscles.isEmpty ? '-' : muscles.first.toUpperCase(),
                    sub: muscles.length > 1 ? '& ${muscles.skip(1).join(', ')}' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InfoTile(
                    label: 'JENIS',
                    value: exercise.kindLabel.toUpperCase(),
                    sub: exercise.isDuration ? 'Tahan posisi' : 'Hitung rep',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _InfoTile(
                    label: 'ALAT',
                    value: exercise.equipmentLabel.toUpperCase(),
                    sub: exercise.isDumbbell ? 'Perlu dumbbell' : 'Tanpa alat',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.videocam_outlined, size: 20, color: AppColors.lime),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PETUNJUK SUDUT KAMERA',
                          style: head.copyWith(fontSize: 16, color: AppColors.lime)),
                      const SizedBox(height: 4),
                      Text(_cameraTip,
                          style: const TextStyle(
                              fontSize: 13, height: 1.45, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (exercise.steps.isNotEmpty) ...[
            const SizedBox(height: 24),
            _SectionHeader(title: 'LANGKAH', trailing: '${exercise.steps.length} LANGKAH'),
            const SizedBox(height: 12),
            for (var i = 0; i < exercise.steps.length; i++) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text((i + 1).toString().padLeft(2, '0'),
                          style: head.copyWith(fontSize: 15, color: AppColors.lime)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(exercise.steps[i],
                            style: const TextStyle(fontSize: 14, height: 1.45)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
          if (exercise.commonMistakes.isNotEmpty) ...[
            const SizedBox(height: 16),
            const _SectionHeader(title: 'KESALAHAN UMUM', badge: 'WASPADAI'),
            const SizedBox(height: 12),
            for (final m in exercise.commonMistakes) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceHigh,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.danger),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(m, style: const TextStyle(fontSize: 14, height: 1.45)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing, this.badge});
  final String title;
  final String? trailing;
  final String? badge;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24)),
          const Spacer(),
          if (trailing != null)
            Text(trailing!,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.lime,
                )),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0x33FF5252),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(badge!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                    color: AppColors.danger,
                  )),
            ),
        ],
      );
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value, this.sub});
  final String label;
  final String value;
  final String? sub;

  @override
  Widget build(BuildContext context) => Container(
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
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                  color: AppColors.textSecondary,
                )),
            const SizedBox(height: 6),
            Text(value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 17, height: 1.1)),
            if (sub != null) ...[
              const SizedBox(height: 4),
              Text(sub!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, height: 1.3, color: Colors.white70)),
            ],
          ],
        ),
      );
}