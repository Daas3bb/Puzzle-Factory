import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Represents a selected image with ordering metadata.
class SelectedImage {
  final XFile xFile;
  final Uint8List bytes;
  int order;

  SelectedImage({
    required this.xFile,
    required this.bytes,
    required this.order,
  });

  String get path => xFile.path;
  String get name => xFile.name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectedImage &&
          runtimeType == other.runtimeType &&
          order == other.order &&
          name == other.name;

  @override
  int get hashCode => Object.hash(order, name);
}

/// The type of puzzle layout.
enum PuzzleLayoutType {
  grid3x3,
  row3,
}
