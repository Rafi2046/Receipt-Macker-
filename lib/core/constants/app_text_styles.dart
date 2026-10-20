import 'package:flutter/material.dart';

/// Type scale. Registered in ThemeData.textTheme; colors come from the theme.
///
/// Noto Sans covers Latin; Noto Sans Bengali is the fallback for Bangla.
/// Bangla needs extra line height for vowel signs above and below the line.
abstract final class AppTextStyles {
  static const String fontFamily = 'NotoSans';
  static const List<String> fontFamilyFallback = ['NotoSansBengali'];

  static const double _tight = 1.3;
  static const double _body = 1.5;

  static const TextStyle displaySm = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: _tight,
  );
  static const TextStyle titleLg = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: _tight,
  );
  static const TextStyle titleMd = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: _tight,
  );
  static const TextStyle titleSm = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: _tight,
  );
  static const TextStyle bodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: _body,
  );
  static const TextStyle bodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: _body,
  );
  static const TextStyle bodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: _body,
  );
  static const TextStyle labelLg = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: _tight,
  );
  static const TextStyle labelMd = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: _tight,
  );
  static const TextStyle labelSm = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: _tight,
  );

  /// Amounts use tabular figures so columns of numbers line up.
  static const TextStyle amountLg = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: _tight,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  static const TextStyle amountMd = TextStyle(
    fontFamily: fontFamily,
    fontFamilyFallback: fontFamilyFallback,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: _tight,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static TextTheme textTheme() => const TextTheme(
    displaySmall: displaySm,
    titleLarge: titleLg,
    titleMedium: titleMd,
    titleSmall: titleSm,
    bodyLarge: bodyLg,
    bodyMedium: bodyMd,
    bodySmall: bodySm,
    labelLarge: labelLg,
    labelMedium: labelMd,
    labelSmall: labelSm,
  ).apply(fontFamily: fontFamily, fontFamilyFallback: fontFamilyFallback);
}
