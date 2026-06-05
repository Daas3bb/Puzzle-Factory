import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class SavedImageResult {
  final String path;

  const SavedImageResult(this.path);
}

Future<SavedImageResult> saveImage(Uint8List bytes, String filename) async {
  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  return SavedImageResult(file.path);
}

Future<SavedImageResult> saveImageToDocuments(
  Uint8List bytes,
  String filename,
) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/$filename');
  await file.writeAsBytes(bytes);
  return SavedImageResult(file.path);
}
