import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

/// Saves PNG bytes to a temporary file and returns the [File].
Future<File> saveImage(Uint8List bytes, String filename) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  return file;
}

/// Saves the image to the app's documents directory for sharing.
Future<File> saveImageToDocuments(Uint8List bytes, String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  return file;
}
