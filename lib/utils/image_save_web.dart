import 'dart:typed_data';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class SavedImageResult {
  final String path;

  const SavedImageResult(this.path);
}

Future<SavedImageResult> saveImage(Uint8List bytes, String filename) async {
  _download(bytes, filename);
  return SavedImageResult(filename);
}

Future<SavedImageResult> saveImageToDocuments(
  Uint8List bytes,
  String filename,
) async {
  _download(bytes, filename);
  return SavedImageResult(filename);
}

void _download(Uint8List bytes, String filename) {
  final blob = html.Blob([bytes], 'image/png');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}
