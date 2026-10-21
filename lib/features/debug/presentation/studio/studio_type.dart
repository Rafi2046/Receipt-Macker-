import 'package:flutter/painting.dart';

/// Type scale for the mock. Amounts use tabular figures.
class StudioType {
  const StudioType(this.family);

  final String family;

  static const List<String> fallback = ['NotoSansBengali'];
  static const double _tight = 1.25;
  static const double _body = 1.45;

  TextStyle display(Color color) => _style(
    size: 34,
    weight: FontWeight.w700,
    height: _tight,
    color: color,
    tabular: true,
  );

  TextStyle title(Color color) =>
      _style(size: 20, weight: FontWeight.w700, height: _tight, color: color);

  TextStyle titleSm(Color color) =>
      _style(size: 16, weight: FontWeight.w600, height: _tight, color: color);

  TextStyle body(Color color) =>
      _style(size: 14, weight: FontWeight.w500, height: _body, color: color);

  TextStyle secondary(Color color) =>
      _style(size: 13, weight: FontWeight.w500, height: _body, color: color);

  TextStyle label(Color color) =>
      _style(size: 12, weight: FontWeight.w600, height: _tight, color: color);

  TextStyle amount(Color color) => _style(
    size: 16,
    weight: FontWeight.w700,
    height: _tight,
    color: color,
    tabular: true,
  );

  TextStyle amountSm(Color color) => _style(
    size: 13,
    weight: FontWeight.w600,
    height: _tight,
    color: color,
    tabular: true,
  );

  TextStyle _style({
    required double size,
    required FontWeight weight,
    required double height,
    required Color color,
    bool tabular = false,
  }) {
    return TextStyle(
      fontFamily: family,
      fontFamilyFallback: fallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color,
      fontFeatures: tabular ? const [FontFeature.tabularFigures()] : null,
    );
  }
}
