import 'dart:convert';

import 'package:flutter/services.dart';

/// The bundled Noto fonts as `@font-face` rules with data URIs, so PDFs
/// look the same on every phone and work offline. Loaded once.
class PdfFonts {
  PdfFonts({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  Future<String>? _css;

  static const String _dir = 'assets/fonts';
  static const List<(String family, String file, int weight)> _faces = [
    ('QB Sans', 'NotoSans-Regular.ttf', 400),
    ('QB Sans', 'NotoSans-Bold.ttf', 700),
    ('QB Bengali', 'NotoSansBengali-Regular.ttf', 400),
    ('QB Bengali', 'NotoSansBengali-Bold.ttf', 700),
  ];

  Future<String> css() => _css ??= _load();

  Future<String> _load() async {
    final rules = StringBuffer();
    for (final (family, file, weight) in _faces) {
      final data = await _bundle.load('$_dir/$file');
      final b64 = base64Encode(data.buffer.asUint8List());
      rules.write(
        "@font-face{font-family:'$family';font-weight:$weight;"
        "src:url(data:font/ttf;base64,$b64) format('truetype');}",
      );
    }
    return rules.toString();
  }
}
