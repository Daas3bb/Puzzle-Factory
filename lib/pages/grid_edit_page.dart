import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/puzzle_provider.dart';
import '../utils/image_exporter.dart';
import '../widgets/puzzle_image.dart';
import 'export_page.dart';

class GridEditPage extends StatefulWidget {
  const GridEditPage({super.key});

  @override
  State<GridEditPage> createState() => _GridEditPageState();
}

class _GridEditPageState extends State<GridEditPage> {
  final GlobalKey _repaintKey = GlobalKey();
  bool _exporting = false;

  static const List<Color> _bgColors = [
    Colors.white,
    Colors.black,
    Color(0xFFFFF3E0),
    Color(0xFFE8F5E9),
    Color(0xFFE3F2FD),
    Color(0xFFFCE4EC),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PuzzleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('3x3 Grid Puzzle'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ---- Preview area ----
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: RepaintBoundary(
                      key: _repaintKey,
                      child: _buildGridPreview(provider),
                    ),
                  ),
                ),
              ),
            ),

            // ---- Controls ----
            _buildControls(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildGridPreview(PuzzleProvider provider) {
    final spacing = provider.spacing.toDouble();
    final radius = provider.borderRadius;
    final bg = provider.backgroundColor;

    return Container(
      color: bg,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        padding: EdgeInsets.all(spacing),
        children: List.generate(9, (index) {
          return _buildGridCell(provider.imageBytesAt(index), radius, bg);
        }),
      ),
    );
  }

  Widget _buildGridCell(Uint8List? bytes, double radius, Color bg) {
    if (bytes == null) {
      // Empty placeholder
      return Container(
        decoration: BoxDecoration(
          color: bg == Colors.white ? Colors.grey.shade200 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey.shade300,
          size: 32,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: PuzzleImage(bytes: bytes, fit: BoxFit.cover),
    );
  }

  Widget _buildControls(PuzzleProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Spacing control
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.space_bar, size: 20, color: Color(0xFF555555)),
                  const SizedBox(width: 8),
                  const Text('Spacing', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  ...List.generate(3, (i) {
                    final values = [0, 2, 4];
                    final v = values[i];
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: ChoiceChip(
                        label: Text('${v}px'),
                        selected: provider.spacing == v,
                        onSelected: (_) => provider.setSpacing(v),
                        labelStyle: const TextStyle(fontSize: 11),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Border radius control
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.rounded_corner, size: 20, color: Color(0xFF555555)),
                  const SizedBox(width: 8),
                  const Text('Corner', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  ...[0.0, 8.0, 16.0].map((v) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: ChoiceChip(
                        label: Text('${v.toInt()}'),
                        selected: provider.borderRadius == v,
                        onSelected: (_) => provider.setBorderRadius(v),
                        labelStyle: const TextStyle(fontSize: 11),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Background color control
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.palette_outlined, size: 20, color: Color(0xFF555555)),
                  const SizedBox(width: 8),
                  const Text('Background', style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  ..._bgColors.map((c) {
                    final isSelected = provider.backgroundColor == c;
                    return GestureDetector(
                      onTap: () => provider.setBackgroundColor(c),
                      child: Container(
                        width: 28,
                        height: 28,
                        margin: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey.shade300,
                            width: isSelected ? 2.5 : 1,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // Export button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _exporting ? null : () => _export(context),
                  icon: _exporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.download),
                  label: Text(_exporting ? 'Exporting...' : 'Export Puzzle'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context) async {
    setState(() => _exporting = true);
    try {
      final Uint8List? bytes = await capturePuzzle(_repaintKey);
      if (!mounted) return;
      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to capture puzzle.')),
        );
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ExportPage(imageBytes: bytes)),
      );
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Grid Puzzle Tips'),
        content: const Text(
          '• Arrange your photos in the picker page.\n'
          '• Use spacing to add gaps between cells.\n'
          '• Adjust corner radius for rounded images.\n'
          '• Choose a background color for empty slots.\n'
          '• Tap Export to save or share your puzzle.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
