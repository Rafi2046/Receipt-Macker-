import 'package:flutter/material.dart';

import 'app_palette.dart';

/// Semantic colors. Widgets read these via `context.appColors`, never raw values.
///
/// Status colors: draft = neutral, sent = info, partially paid = warning,
/// paid = success, overdue = danger. Always pair them with a text label.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.danger,
    required this.info,
    required this.neutral,
  });

  factory AppColors.light(AppPalette p) => AppColors(
    primary: p.lightPrimary,
    onPrimary: p.lightOnPrimary,
    secondary: p.lightSecondary,
    onSecondary: p.lightOnSecondary,
    background: const Color(0xFFF3F5F7),
    surface: const Color(0xFFFFFFFF),
    surfaceAlt: const Color(0xFFF3F5F7),
    border: const Color(0xFFD9DEE3),
    textPrimary: const Color(0xFF14181C),
    textSecondary: const Color(0xFF56606B),
    success: const Color(0xFF15803D),
    warning: const Color(0xFFB45309),
    danger: const Color(0xFFB91C1C),
    info: const Color(0xFF1D4ED8),
    neutral: const Color(0xFF475569),
  );

  factory AppColors.dark(AppPalette p) => AppColors(
    primary: p.darkPrimary,
    onPrimary: p.darkOnPrimary,
    secondary: p.darkSecondary,
    onSecondary: p.darkOnSecondary,
    background: const Color(0xFF111316),
    surface: const Color(0xFF1A1D21),
    surfaceAlt: const Color(0xFF24282D),
    border: const Color(0xFF33383E),
    textPrimary: const Color(0xFFECEFF2),
    textSecondary: const Color(0xFFA3ACB6),
    success: const Color(0xFF4ADE80),
    warning: const Color(0xFFFBBF24),
    danger: const Color(0xFFF87171),
    info: const Color(0xFF60A5FA),
    neutral: const Color(0xFF94A3B8),
  );

  final Color primary, onPrimary, secondary, onSecondary;
  final Color background, surface, surfaceAlt, border;
  final Color textPrimary, textSecondary;
  final Color success, warning, danger, info, neutral;

  @override
  AppColors copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? warning,
    Color? danger,
    Color? info,
    Color? neutral,
  }) => AppColors(
    primary: primary ?? this.primary,
    onPrimary: onPrimary ?? this.onPrimary,
    secondary: secondary ?? this.secondary,
    onSecondary: onSecondary ?? this.onSecondary,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    surfaceAlt: surfaceAlt ?? this.surfaceAlt,
    border: border ?? this.border,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    danger: danger ?? this.danger,
    info: info ?? this.info,
    neutral: neutral ?? this.neutral,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t) ?? a;
    return AppColors(
      primary: mix(primary, other.primary),
      onPrimary: mix(onPrimary, other.onPrimary),
      secondary: mix(secondary, other.secondary),
      onSecondary: mix(onSecondary, other.onSecondary),
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceAlt: mix(surfaceAlt, other.surfaceAlt),
      border: mix(border, other.border),
      textPrimary: mix(textPrimary, other.textPrimary),
      textSecondary: mix(textSecondary, other.textSecondary),
      success: mix(success, other.success),
      warning: mix(warning, other.warning),
      danger: mix(danger, other.danger),
      info: mix(info, other.info),
      neutral: mix(neutral, other.neutral),
    );
  }
}

extension AppThemeX on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light(AppPalette.teal);
  TextTheme get textStyles => Theme.of(this).textTheme;
}
