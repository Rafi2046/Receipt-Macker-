import 'package:flutter/painting.dart';

/// Colors of things that stand for paper (signature pad, image previews,
/// later the PDF preview). They stay the same in light and dark mode because
/// the printed invoice is always dark ink on white.
abstract final class AppDocumentColors {
  static const Color paper = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF111418);
}
