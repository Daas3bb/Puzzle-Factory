import 'package:image_picker/image_picker.dart';

/// Represents a selected image with ordering metadata.
class SelectedImage {
  final XFile xFile;
  int order;

  SelectedImage({required this.xFile, required this.order});

  String get path => xFile.path;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedImage && runtimeType == other.runtimeType && path == other.path;

  @override
  int get hashCode => path.hashCode;
}

/// The type of puzzle layout.
enum PuzzleLayoutType {
  grid3x3,
  row3,
}
