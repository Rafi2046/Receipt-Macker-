import 'dart:typed_data';

import 'package:printing/printing.dart';

/// Renders PDF pages to PNG images for the in-app preview.
class PdfRasterService {
  /// Enough for a sharp preview on phones without using much memory.
  static const double previewDpi = 110;

  Future<List<Uint8List>> pages(
    Uint8List pdf, {
    double dpi = previewDpi,
  }) async {
    final images = <Uint8List>[];
    await for (final page in Printing.raster(pdf, dpi: dpi)) {
      images.add(await page.toPng());
    }
    return images;
  }
}
