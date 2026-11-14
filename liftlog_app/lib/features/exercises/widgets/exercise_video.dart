import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../../core/theme/app_colors.dart';
import '../models/exercise.dart';

/// Origin pemutar = "https://" + applicationId aplikasi (lihat applicationId di
/// android/app/build.gradle.kts). Tanpa ini embed bisa ditolak (error 152/153).
const kYoutubeOrigin = 'https://com.example.liftlog_app';

class ExerciseVideo extends StatefulWidget {
  const ExerciseVideo({super.key, required this.exercise});
  final Exercise exercise;

  @override
  State<ExerciseVideo> createState() => _ExerciseVideoState();
}

class _ExerciseVideoState extends State<ExerciseVideo> {
  YoutubePlayerController? _controller;

  void _play() {
    final id = widget.exercise.youtubeId;
    if (id == null) return;
    setState(() {
      _controller = YoutubePlayerController.fromVideoId(
        videoId: id,
        autoPlay: true,
        params: const YoutubePlayerParams(
          origin: kYoutubeOrigin,
          showFullscreenButton: true,
        ),
      );
    });
  }

  Future<void> _openYoutube() async {
    final url = widget.exercise.youtubeUrl;
    if (url == null) return;
    var ok = false;
    try {
      ok = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      ok = false;
    }
    if (!ok && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Tidak bisa membuka YouTube.')));
    }
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ex = widget.exercise;
    final source = ex.videoSourceLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _controller != null
                ? YoutubePlayer(controller: _controller!, aspectRatio: 16 / 9)
                : _Thumb(url: ex.thumbnailUrl(hq: true), onTap: ex.youtubeId == null ? null : _play),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                source == null ? 'Sumber: YouTube' : 'Sumber: YouTube · $source',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, height: 1.3, color: AppColors.textSecondary),
              ),
            ),
            if (ex.youtubeUrl != null)
              TextButton.icon(
                onPressed: _openYoutube,
                icon: const Icon(Icons.open_in_new, size: 14),
                label: const Text('Buka di YouTube'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white70,
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url, required this.onTap});
  final String? url;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url != null)
              Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) =>
                    const ColoredBox(color: AppColors.surfaceHigh),
              )
            else
              const ColoredBox(color: AppColors.surfaceHigh),
            const DecoratedBox(decoration: BoxDecoration(color: Color(0x44000000))),
            Center(
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow_rounded, size: 34, color: Colors.black),
              ),
            ),
          ],
        ),
      );
}