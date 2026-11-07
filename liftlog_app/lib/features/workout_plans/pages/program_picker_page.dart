import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/program_template.dart';

class ProgramPickerPage extends StatefulWidget {
  const ProgramPickerPage({super.key, required this.templates, this.currentId});

  final List<ProgramTemplate> templates;
  final int? currentId;

  @override
  State<ProgramPickerPage> createState() => _ProgramPickerPageState();
}

class _ProgramPickerPageState extends State<ProgramPickerPage> {
  static const _levels = <(String?, String)>[
    (null, 'SEMUA TINGKAT'),
    ('beginner', 'PEMULA'),
    ('intermediate', 'MENENGAH'),
    ('advanced', 'LANJUT'),
  ];

  String? _level;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final list = widget.templates.where((t) => _level == null || t.level == _level).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(backgroundColor: AppColors.surface),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        children: [
          const Text('KATALOG PROGRAM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
                color: AppColors.lime,
              )),
          const SizedBox(height: 8),
          Text('PILIH PROGRAM', style: text.displayMedium?.copyWith(fontSize: 40)),
          const SizedBox(height: 8),
          const Text(
            'Pilih rencana latihan yang sesuai dengan ketersediaan waktu dan target kekuatanmu.',
            style: TextStyle(fontSize: 15, height: 1.4, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final l in _levels) ...[
                  _FilterChip(
                    label: l.$2,
                    selected: _level == l.$1,
                    onTap: () => setState(() => _level = l.$1),
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Text('Belum ada program untuk tingkat ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          for (var i = 0; i < list.length; i += 2)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _ProgramCard(
                        t: list[i],
                        current: list[i].id == widget.currentId,
                        onPick: () => Navigator.of(context).pop(list[i]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: i + 1 < list.length
                          ? _ProgramCard(
                              t: list[i + 1],
                              current: list[i + 1].id == widget.currentId,
                              onPick: () => Navigator.of(context).pop(list[i + 1]),
                            )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          if (list.isNotEmpty) ...[
            const SizedBox(height: 8),
            _Comparison(list: list, currentId: widget.currentId),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 20, color: AppColors.lime),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Program dapat diganti kapan saja tanpa menghapus riwayat latihanmu.',
                    style: TextStyle(fontSize: 14, height: 1.45, color: Colors.white70),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.lime : AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
                color: selected ? Colors.black : Colors.white70,
              )),
        ),
      );
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({required this.t, required this.current, required this.onPick});
  final ProgramTemplate t;
  final bool current;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: current ? AppColors.lime : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3C),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(levelLabel(t.level).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    )),
              ),
            ),
            const SizedBox(height: 12),
            Text(t.name.toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
            const SizedBox(height: 4),
            Text('${t.days}x per minggu',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            _Field(label: 'DURASI', value: '~${t.estimatedMinutes} mnt / sesi'),
            const SizedBox(height: 8),
            _Field(label: 'FOKUS UTAMA', value: _capitalize(goalLabel(t.goal))),
            const SizedBox(height: 8),
            _Field(label: 'PERALATAN', value: t.equipmentLabel()),
            const Spacer(),
            const SizedBox(height: 14),
            OutlinedButton(
              onPressed: onPick,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                foregroundColor: current ? Colors.black : Colors.white,
                backgroundColor: current ? AppColors.lime : AppColors.surface,
                side: BorderSide(color: current ? AppColors.lime : AppColors.border),
                shape: const StadiumBorder(),
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              child: Text(current ? 'DIPILIH' : 'PILIH  →'),
            ),
          ],
        ),
      );

  static String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: AppColors.lime,
              )),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, height: 1.3, color: Colors.white)),
        ],
      );
}

class _Comparison extends StatelessWidget {
  const _Comparison({required this.list, required this.currentId});
  final List<ProgramTemplate> list;
  final int? currentId;

  @override
  Widget build(BuildContext context) {
    final maxSets = list.map((t) => t.totalSets).fold<int>(1, (a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            children: [
              Expanded(
                child: Text('PERBANDINGAN BEBAN MINGGUAN',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    )),
              ),
              Text('ESTIMASI SET',
                  style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 14),
          for (final t in list) ...[
            Row(
              children: [
                Expanded(
                  child: Text(t.name.toUpperCase(),
                      style: const TextStyle(fontSize: 12, color: Colors.white70)),
                ),
                Text('${t.totalSets} SET / MINGGU',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: t.id == currentId ? AppColors.lime : Colors.white70,
                    )),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: t.totalSets / maxSets,
                minHeight: 8,
                backgroundColor: AppColors.border,
                color: t.id == currentId ? AppColors.lime : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}