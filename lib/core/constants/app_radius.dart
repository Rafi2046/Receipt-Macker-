import 'package:flutter/widgets.dart';

/// Corner radii.
abstract final class AppRadius {
  static const double sm = 8, md = 12, lg = 16, xl = 28, pill = 999;
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));
  static const BorderRadius input = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius dock = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius button = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius chip = BorderRadius.all(Radius.circular(pill));
}
