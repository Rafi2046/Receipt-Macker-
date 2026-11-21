import 'package:flutter/widgets.dart';

/// Corner radii.
abstract final class AppRadius {
  static const double sm = 8, md = 12, lg = 16, pill = 999;
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));

  /// Top corners of a bottom sheet.
  static const BorderRadius sheet = BorderRadius.vertical(
    top: Radius.circular(24),
  );
  static const BorderRadius input = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(pill));
}
