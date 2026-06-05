import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'image_save_io.dart' if (dart.library.html) 'image_save_web.dart';

export 'image_save_io.dart' if (dart.library.html) 'image_save_web.dart';

/// Captures a widget wrapped in a [RepaintBoundary] and returns PNG bytes.
Future<Uint8List?> capturePuzzle(GlobalKey key) async {
  try {
    final boundary = key.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  } catch (e) {
    debugPrint('capturePuzzle error: $e');
    return null;
  }
}
