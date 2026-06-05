import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/selected_image.dart';

/// State management for puzzle editing.
class PuzzleProvider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  // ---- Image list ----
  List<SelectedImage> _images = [];
  List<SelectedImage> get images => List.unmodifiable(_images);
  int get imageCount => _images.length;

  // ---- Layout ----
  PuzzleLayoutType _layoutType = PuzzleLayoutType.grid3x3;
  PuzzleLayoutType get layoutType => _layoutType;

  // ---- Style ----
  int _spacing = 0; // 0, 2, 4
  int get spacing => _spacing;

  double _borderRadius = 0.0;
  double get borderRadius => _borderRadius;

  Color _backgroundColor = Colors.white;
  Color get backgroundColor => _backgroundColor;

  // ---- Image operations ----

  Future<void> pickImages({int maxCount = 9, bool append = false}) async {
    final List<XFile> picked = kIsWeb
        ? await _picker.pickMultiImage(imageQuality: 100)
        : await _picker.pickMultiImage(
            limit: maxCount,
            imageQuality: 100,
          );
    if (picked.isEmpty) return;

    final limited = picked.take(maxCount).toList();
    final selected = await Future.wait(
      limited.asMap().entries.map((entry) async {
        final bytes = await entry.value.readAsBytes();
        return SelectedImage(
          xFile: entry.value,
          bytes: bytes,
          order: entry.key,
        );
      }),
    );

    if (append) {
      for (final image in selected) {
        if (_images.length >= maxCount) break;
        image.order = _images.length;
        _images.add(image);
      }
    } else {
      _images = selected;
    }

    _reorder();
    notifyListeners();
  }

  Future<void> addImage(XFile file) async {
    final bytes = await file.readAsBytes();
    _images.add(SelectedImage(xFile: file, bytes: bytes, order: _images.length));
    notifyListeners();
  }

  void removeImage(int index) {
    if (index < 0 || index >= _images.length) return;
    _images.removeAt(index);
    _reorder();
    notifyListeners();
  }

  void reorder(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) newIndex--;
    final item = _images.removeAt(oldIndex);
    _images.insert(newIndex, item);
    _reorder();
    notifyListeners();
  }

  void _reorder() {
    for (int i = 0; i < _images.length; i++) {
      _images[i].order = i;
    }
  }

  void clearImages() {
    _images.clear();
    notifyListeners();
  }

  // ---- Style operations ----

  void setLayoutType(PuzzleLayoutType type) {
    _layoutType = type;
    notifyListeners();
  }

  void setSpacing(int value) {
    _spacing = value;
    notifyListeners();
  }

  void setBorderRadius(double value) {
    _borderRadius = value;
    notifyListeners();
  }

  void setBackgroundColor(Color color) {
    _backgroundColor = color;
    notifyListeners();
  }

  // ---- Helpers ----

  String? imagePathAt(int index) {
    if (index < 0 || index >= _images.length) return null;
    return _images[index].path;
  }

  Uint8List? imageBytesAt(int index) {
    if (index < 0 || index >= _images.length) return null;
    return _images[index].bytes;
  }

  SelectedImage? imageAt(int index) {
    if (index < 0 || index >= _images.length) return null;
    return _images[index];
  }

  int get maxImages =>
      _layoutType == PuzzleLayoutType.grid3x3 ? 9 : 3;
}
