import 'dart:ui' show Color;

import 'hex_color.dart';

/// An opaque [Color] from `#RRGGBB`; [fallback] when [hex] is not a color.
Color colorFromHex(String? hex, {required Color fallback}) {
  final value = HexColor.rgb(hex);
  return value == null ? fallback : Color(0xFF000000 | value);
}
