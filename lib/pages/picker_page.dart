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
    final layoutType = provider.layoutType;
    final maxImages = provider.maxImages;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          layoutType == PuzzleLayoutType.grid3x3
              ? 'Select Photos (Grid 3x3)'
              : 'Select Photos (Row)',
        ),
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
          // Instruction banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: const Color(0xFFFFF3E0),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 18, color: Color(0xFFE65100)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    layoutType == PuzzleLayoutType.grid3x3
                        ? 'Select up to 9 photos for the 3x3 grid.'
                        : 'Select up to 3 photos for the row layout.',
                    style: const TextStyle(fontSize: 13, color: Color(0xFFBF360C)),
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
            'No photos selected',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to pick images',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => provider.pickImages(maxCount: maxImages),
            icon: const Icon(Icons.photo_library),
            label: const Text('Select from Album'),
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
          'Photo ${index + 1}',
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
    final layoutType = provider.layoutType;
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
                onPressed: () => provider.pickImages(maxCount: provider.maxImages),
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text('Add More'),
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
                label: Text(provider.imageCount > 0 ? 'Start Puzzle' : 'Select Photos First'),
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
