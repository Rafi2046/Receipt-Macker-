import 'package:flutter/material.dart';

/// Semantic colors. Brand: bottle green + gold (owner decision, M0).
/// Widgets read these via `context.appColors`, never raw values.
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
    required this.onDanger,
    required this.info,
    required this.neutral,
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
    required this.onHeroMuted,
  });

  factory AppColors.light() => const AppColors(
    primary: Color(0xFF006A4E),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFE0A100),
    onSecondary: Color(0xFF241A00),
    background: Color(0xFFF3F5F7),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF3F5F7),
    border: Color(0xFFD9DEE3),
    textPrimary: Color(0xFF14181C),
    textSecondary: Color(0xFF56606B),
    success: Color(0xFF15803D),
    warning: Color(0xFFB45309),
    danger: Color(0xFFB91C1C),
    onDanger: Color(0xFFFFFFFF),
    info: Color(0xFF1D4ED8),
    neutral: Color(0xFF475569),
    heroStart: Color(0xFF0B5E48),
    heroEnd: Color(0xFF004233),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xD6FFFFFF),
  );

  factory AppColors.dark() => const AppColors(
    primary: Color(0xFF3DDC97),
    onPrimary: Color(0xFF06281C),
    secondary: Color(0xFFF5C542),
    onSecondary: Color(0xFF241A00),
    background: Color(0xFF0E1114),
    surface: Color(0xFF1A1F24),
    surfaceAlt: Color(0xFF24292E),
    border: Color(0xFF2C343C),
    textPrimary: Color(0xFFF2F5F7),
    textSecondary: Color(0xFF9AA3AB),
    success: Color(0xFF4ADE80),
    warning: Color(0xFFFBBF24),
    danger: Color(0xFFF87171),
    onDanger: Color(0xFF2A0707),
    info: Color(0xFF60A5FA),
    neutral: Color(0xFF94A3B8),
    heroStart: Color(0xFF146B52),
    heroEnd: Color(0xFF0B3B2E),
    onHero: Color(0xFFF4FFF9),
    onHeroMuted: Color(0xCCE7FFF4),
  );

  final Color primary, onPrimary, secondary, onSecondary;
  final Color background, surface, surfaceAlt, border;
  final Color textPrimary, textSecondary;
  final Color success, warning, danger, onDanger, info, neutral;
  final Color heroStart, heroEnd, onHero, onHeroMuted;

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
    Color? onDanger,
    Color? info,
    Color? neutral,
    Color? heroStart,
    Color? heroEnd,
    Color? onHero,
    Color? onHeroMuted,
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
    onDanger: onDanger ?? this.onDanger,
    info: info ?? this.info,
    neutral: neutral ?? this.neutral,
    heroStart: heroStart ?? this.heroStart,
    heroEnd: heroEnd ?? this.heroEnd,
    onHero: onHero ?? this.onHero,
    onHeroMuted: onHeroMuted ?? this.onHeroMuted,
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
      onDanger: mix(onDanger, other.onDanger),
      info: mix(info, other.info),
      neutral: mix(neutral, other.neutral),
      heroStart: mix(heroStart, other.heroStart),
      heroEnd: mix(heroEnd, other.heroEnd),
      onHero: mix(onHero, other.onHero),
      onHeroMuted: mix(onHeroMuted, other.onHeroMuted),
    );
  }
}

extension AppThemeX on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light();
  TextTheme get textStyles => Theme.of(this).textTheme;
}
