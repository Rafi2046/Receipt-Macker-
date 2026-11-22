import 'dart:io';
import 'dart:ui' as ui;

import '../utils/hex_color.dart';

/// Finds the main color of an image file (the business logo), so it can be
/// offered as the invoice accent.
class ImageColorService {
  /// Small decode size: enough pixels to find the main color, cheap to scan.
  static const int _sampleWidth = 64;

  /// `#RRGGBB`, or null when the file is missing, unreadable or grey.
  Future<String?> dominantHex(String path) async {
    final file = File(path);
    if (!file.existsSync()) return null;
    try {
      final bytes = await file.readAsBytes();
      final codec = await ui.instantiateImageCodec(
        bytes,
        targetWidth: _sampleWidth,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData();
      frame.image.dispose();
      codec.dispose();
      if (data == null) return null;
      return HexColor.dominant(data.buffer.asUint8List());
    } on Exception {
      return null;
    }
  }
}
