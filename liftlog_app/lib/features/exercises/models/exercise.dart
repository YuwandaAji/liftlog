class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.type,
    required this.kind,
    required this.jointA,
    required this.jointB,
    required this.jointC,
    required this.lowerAngle,
    required this.upperAngle,
    required this.targetMuscle,
    this.youtubeId,
    this.videoSource,
    required this.steps,
    required this.commonMistakes,
    required this.cameraPosition,
  });

  final int id;
  final String name;
  final String type; // bodyweight | dumbbell
  final String kind; // reps | duration
  final String jointA;
  final String jointB;
  final String jointC;
  final int lowerAngle;
  final int upperAngle;
  final String targetMuscle;
  final String? youtubeId;
  final String? videoSource;
  final List<String> steps;
  final List<String> commonMistakes;
  final String cameraPosition; // side | front

  factory Exercise.fromJson(Map<String, dynamic> j) {
    int i(String k) => int.tryParse('${j[k]}') ?? 0;
    String s(String k) => '${j[k] ?? ''}';
    String? opt(String k) {
      final v = s(k).trim();
      return v.isEmpty ? null : v;
    }

    return Exercise(
      id: i('id'),
      name: s('name'),
      type: s('type'),
      kind: s('kind'),
      jointA: s('joint_a'),
      jointB: s('joint_b'),
      jointC: s('joint_c'),
      lowerAngle: i('lower_angle'),
      upperAngle: i('upper_angle'),
      targetMuscle: s('target_muscle'),
      youtubeId: opt('youtube_id'),
      videoSource: opt('video_source'),
      steps: _lines(s('steps'), stripNumber: true),
      commonMistakes: _lines(s('common_mistakes')),
      cameraPosition: s('camera_position'),
    );
  }

  /// Teks per baris; `stripNumber` membuang awalan "1. " pada langkah.
  static List<String> _lines(String text, {bool stripNumber = false}) => text
      .split(RegExp(r'\r?\n'))
      .map((l) => stripNumber ? l.replaceFirst(RegExp(r'^\s*\d+[.)]\s*'), '') : l)
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  bool get isDumbbell => type == 'dumbbell';
  bool get isDuration => kind == 'duration';

  String get typeLabel => isDumbbell ? 'DUMBBELL' : 'BODYWEIGHT';
  String get equipmentLabel => isDumbbell ? 'Dumbbell' : 'Beban tubuh';
  String get kindLabel => isDuration ? 'Durasi' : 'Repetisi';
  String get cameraLabel => cameraPosition == 'front' ? 'Depan' : 'Samping';

  List<String> get muscles =>
      targetMuscle.split(',').map((m) => m.trim()).where((m) => m.isNotEmpty).toList();

  /// Kartu katalog memakai mqdefault (16:9, tanpa pita hitam).
  /// hqdefault (4:3) dipakai di kotak 16:9 dengan BoxFit.cover, pitanya terpotong.
  String? thumbnailUrl({bool hq = false}) => youtubeId == null
      ? null
      : 'https://img.youtube.com/vi/$youtubeId/${hq ? 'hqdefault' : 'mqdefault'}.jpg';

  String? get youtubeUrl =>
      youtubeId == null ? null : 'https://www.youtube.com/watch?v=$youtubeId';

  /// Sumber video, atau null bila masih placeholder "ISI: ...".
  String? get videoSourceLabel {
    final v = videoSource;
    return (v == null || v.startsWith('ISI:')) ? null : v;
  }

  String get slug => name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
      .replaceAll(RegExp(r'^_+|_+$'), '');

  String get imageAsset => 'assets/images/exercises/$slug.jpg';
}