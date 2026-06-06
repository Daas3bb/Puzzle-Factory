import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/selected_image.dart';
import '../providers/puzzle_provider.dart';
import '../widgets/puzzle_image.dart';
import 'collage_edit_page.dart';

class PickerPage extends StatelessWidget {
  const PickerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PuzzleProvider>();
    final maxImages = provider.maxImages;
    final hasScenario = provider.activeTemplate != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(hasScenario ? provider.templateName : '选择图片'),
        actions: [
          if (provider.imageCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '${provider.imageCount}/$maxImages',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFFEDE7F6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  hasScenario ? Icons.auto_awesome : Icons.info_outline,
                  size: 18,
                  color: const Color(0xFF7B5CF6),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasScenario)
                        Text(
                          provider.scenarioTitle,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF5E35B1),
                          ),
                        ),
                      Text(
                        provider.pickerHint,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4527A0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Selected images area
          Expanded(
            child: provider.imageCount == 0
                ? _buildEmptyState(context, provider, maxImages)
                : _buildImageList(context, provider),
          ),

          // Bottom bar
          _buildBottomBar(context, provider),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, PuzzleProvider provider, int maxImages) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            '还没有选择图片',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            '点击下方按钮从相册选取',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => provider.pickImages(maxCount: maxImages),
            icon: const Icon(Icons.photo_library),
            label: const Text('从相册选择'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageList(BuildContext context, PuzzleProvider provider) {
    return ReorderableListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: provider.imageCount,
      onReorder: provider.reorder,
      itemBuilder: (context, index) {
        final image = provider.imageAt(index)!;
        return _buildImageTile(context, provider, index, image);
      },
    );
  }

  Widget _buildImageTile(
    BuildContext context,
    PuzzleProvider provider,
    int index,
    SelectedImage image,
  ) {
    return Container(
      key: ValueKey('${image.order}_${image.name}'),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 60,
            height: 60,
            child: PuzzleImage(bytes: image.bytes, fit: BoxFit.cover),
          ),
        ),
        title: Text(
          '图片 ${index + 1}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          image.name,
          style: const TextStyle(fontSize: 11),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.drag_handle, color: Colors.grey.shade400),
            IconButton(
              icon: Icon(Icons.close, color: Colors.grey.shade400, size: 20),
              onPressed: () => provider.removeImage(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, PuzzleProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => provider.pickImages(
                  maxCount: provider.maxImages,
                  append: true,
                ),
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('继续添加'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: provider.imageCount > 0
                    ? () => _goToEditor(context)
                    : null,
                icon: const Icon(Icons.check),
                label: Text(provider.imageCount > 0 ? '开始创作' : '请先选择图片'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToEditor(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CollageEditPage()),
    );
  }
}
