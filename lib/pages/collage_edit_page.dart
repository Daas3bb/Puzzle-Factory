import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/selected_image.dart';
import '../providers/puzzle_provider.dart';
import '../utils/image_exporter.dart';
import '../widgets/puzzle_image.dart';
import 'export_page.dart';

class CollageEditPage extends StatefulWidget {
  const CollageEditPage({super.key});

  @override
  State<CollageEditPage> createState() => _CollageEditPageState();
}

class _CollageEditPageState extends State<CollageEditPage> {
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

  static const Color _accent = Color(0xFF7B5CF6);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PuzzleProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF333333),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers_outlined, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.undo, size: 22),
            onPressed: () => _showTip('撤销功能即将上线'),
          ),
          IconButton(
            icon: const Icon(Icons.redo, size: 22),
            onPressed: () => _showTip('重做功能即将上线'),
          ),
          IconButton(
            icon: const Icon(Icons.ios_share, size: 22),
            onPressed: _exporting ? null : () => _export(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _exporting ? null : () => _export(context),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: _exporting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      '保存',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: provider.layoutType == PuzzleLayoutType.grid3x3
                      ? _buildGridPreview(provider)
                      : _buildRowPreview(provider),
                ),
              ),
            ),
          ),
          _buildBottomToolbar(provider),
        ],
      ),
    );
  }

  Widget _buildGridPreview(PuzzleProvider provider) {
    final spacing = provider.spacing.toDouble();
    final radius = provider.borderRadius;
    final bg = provider.backgroundColor;

    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          padding: EdgeInsets.all(spacing),
          children: List.generate(9, (index) {
            return _buildImageCell(provider.imageBytesAt(index), radius, bg);
          }),
        ),
      ),
    );
  }

  Widget _buildRowPreview(PuzzleProvider provider) {
    final spacing = provider.spacing.toDouble();
    final radius = provider.borderRadius;
    final bg = provider.backgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(spacing),
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: index > 0 ? spacing / 2 : 0,
                right: index < 2 ? spacing / 2 : 0,
              ),
              child: _buildImageCell(provider.imageBytesAt(index), radius, bg),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildImageCell(Uint8List? bytes, double radius, Color bg) {
    if (bytes == null) {
      return Container(
        decoration: BoxDecoration(
          color: bg == Colors.white ? Colors.grey.shade200 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey.shade300,
          size: 28,
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: PuzzleImage(bytes: bytes, fit: BoxFit.cover),
    );
  }

  Widget _buildBottomToolbar(PuzzleProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ToolbarItem(
                icon: Icons.add_photo_alternate_outlined,
                label: '添加照片',
                onTap: () => provider.pickImages(
                  maxCount: provider.maxImages,
                  append: true,
                ),
              ),
              _ToolbarItem(
                icon: Icons.view_column_outlined,
                label: '布局',
                onTap: () => _showLayoutSheet(provider),
              ),
              _ToolbarItem(
                icon: Icons.texture_outlined,
                label: '背景',
                onTap: () => _showBackgroundSheet(provider),
              ),
              _ToolbarItem(
                icon: Icons.emoji_emotions_outlined,
                label: '贴纸',
                onTap: () => _showTip('贴纸功能即将上线'),
              ),
              _ToolbarItem(
                icon: Icons.text_fields,
                label: '文本',
                onTap: () => _showTip('文本功能即将上线'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLayoutSheet(PuzzleProvider provider) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '选择布局',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _LayoutOption(
                      title: '九宫格',
                      icon: Icons.grid_on,
                      selected: provider.layoutType == PuzzleLayoutType.grid3x3,
                      onTap: () {
                        provider.setLayoutType(PuzzleLayoutType.grid3x3);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _LayoutOption(
                      title: '三栏横拼',
                      icon: Icons.view_week_outlined,
                      selected: provider.layoutType == PuzzleLayoutType.row3,
                      onTap: () {
                        provider.setLayoutType(PuzzleLayoutType.row3);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('间距', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final v in [0, 2, 4])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${v}px'),
                        selected: provider.spacing == v,
                        onSelected: (_) => provider.setSpacing(v),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('圆角', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final v in [0.0, 8.0, 16.0])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${v.toInt()}'),
                        selected: provider.borderRadius == v,
                        onSelected: (_) => provider.setBorderRadius(v),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBackgroundSheet(PuzzleProvider provider) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '背景颜色',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _bgColors.map((color) {
                  final selected = provider.backgroundColor == color;
                  return GestureDetector(
                    onTap: () => provider.setBackgroundColor(color),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? _accent : Colors.grey.shade300,
                          width: selected ? 3 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _export(BuildContext context) async {
    setState(() => _exporting = true);
    try {
      final Uint8List? bytes = await capturePuzzle(_repaintKey);
      if (!mounted) return;
      if (bytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存失败，请重试')),
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

  void _showTip(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}

class _ToolbarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ToolbarItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: const Color(0xFF444444)),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
            ),
          ],
        ),
      ),
    );
  }
}

class _LayoutOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _LayoutOption({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEDE7F6) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF7B5CF6) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: const Color(0xFF7B5CF6)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
