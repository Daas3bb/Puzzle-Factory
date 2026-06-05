import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/image_exporter.dart';

class ExportPage extends StatefulWidget {
  final Uint8List imageBytes;

  const ExportPage({super.key, required this.imageBytes});

  @override
  State<ExportPage> createState() => _ExportPageState();
}

class _ExportPageState extends State<ExportPage> {
  bool _saving = false;
  bool _sharing = false;
  String? _savedPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Puzzle'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(
                      widget.imageBytes,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            if (_savedPath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        kIsWeb ? '已触发下载：$_savedPath' : 'Saved to: $_savedPath',
                        style: const TextStyle(fontSize: 12, color: Colors.green),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saving ? null : _saveToAlbum,
                          icon: _saving
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(kIsWeb ? Icons.download : Icons.save_alt),
                          label: Text(kIsWeb ? '下载图片' : 'Save to Album'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _sharing ? null : _shareImage,
                          icon: _sharing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.share),
                          label: const Text('Share'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                      child: const Text('Start Over'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToAlbum() async {
    setState(() => _saving = true);
    try {
      final filename = 'puzzle_${DateTime.now().millisecondsSinceEpoch}.png';
      final result = await saveImageToDocuments(widget.imageBytes, filename);
      if (!mounted) return;

      setState(() {
        _savedPath = result.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            kIsWeb ? '图片已开始下载' : 'Image saved to ${result.path}',
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _shareImage() async {
    setState(() => _sharing = true);
    try {
      final filename = 'puzzle_${DateTime.now().millisecondsSinceEpoch}.png';

      if (kIsWeb) {
        await Share.shareXFiles(
          [
            XFile.fromData(
              widget.imageBytes,
              mimeType: 'image/png',
              name: filename,
            ),
          ],
          text: 'Check out my puzzle!',
        );
      } else {
        final result = await saveImage(widget.imageBytes, filename);
        await Share.shareXFiles(
          [XFile(result.path, mimeType: 'image/png')],
          text: 'Check out my puzzle!',
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to share: $e')),
      );
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }
}
