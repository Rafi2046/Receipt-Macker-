import 'dart:typed_data';

/// A PDF written to the cache folder, ready to preview, share or print.
class RenderedPdf {
  const RenderedPdf({
    required this.path,
    required this.fileName,
    required this.pageCount,
    required this.bytes,
  });

  final String path;

  /// e.g. `INV-0001.pdf`.
  final String fileName;
  final int pageCount;
  final Uint8List bytes;

  static const String mimeType = 'application/pdf';
}
