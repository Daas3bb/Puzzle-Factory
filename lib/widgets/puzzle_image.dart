import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Cross-platform image widget backed by in-memory bytes (works on Web + mobile).
class PuzzleImage extends StatelessWidget {
  final Uint8List? bytes;
  final BoxFit fit;
  final double? width;
  final double? height;

  const PuzzleImage({
    super.key,
    required this.bytes,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (bytes == null || bytes!.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    return Image.memory(
      bytes!,
      fit: fit,
      width: width,
      height: height,
      gaplessPlayback: true,
      errorBuilder: (_, _, _) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}
