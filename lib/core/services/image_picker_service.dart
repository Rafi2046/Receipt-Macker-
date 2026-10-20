import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// A picked image: its bytes and a lowercase file extension.
typedef PickedImage = ({Uint8List bytes, String extension});

/// Wraps the system photo picker so ViewModels never touch the plugin.
class ImagePickerService {
  ImagePickerService([ImagePicker? picker]) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Logos are downscaled; invoices never need more than this.
  static const double maxDimension = 1024;
  static const int jpegQuality = 90;

  /// Returns null when the user cancels.
  Future<PickedImage?> pickFromGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: maxDimension,
      maxHeight: maxDimension,
      imageQuality: jpegQuality,
    );
    if (file == null) return null;
    final dot = file.name.lastIndexOf('.');
    final ext = dot < 0 ? 'jpg' : file.name.substring(dot + 1).toLowerCase();
    return (bytes: await file.readAsBytes(), extension: ext);
  }
}
