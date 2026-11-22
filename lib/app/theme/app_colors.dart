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
    required this.panel,
    required this.onPanel,
    required this.onPanelMuted,
  });

  factory AppColors.light() => const AppColors(
    primary: Color(0xFFFF5738),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF2563EB),
    onSecondary: Color(0xFFFFFFFF),
    background: Color(0xFFF7F8FA),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFF1F3F6),
    border: Color(0xFFE5E7EB),
    textPrimary: Color(0xFF111827),
    textSecondary: Color(0xFF6B7280),
    success: Color(0xFF10B981),
    warning: Color(0xFFF59E0B),
    danger: Color(0xFFFF5738),
    onDanger: Color(0xFFFFFFFF),
    info: Color(0xFF2563EB),
    neutral: Color(0xFF64748B),
    heroStart: Color(0xFFFF6548),
    heroEnd: Color(0xFFE54326),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xEEFFFFFF),
    panel: Color(0xFF111827),
    onPanel: Color(0xFFFFFFFF),
    onPanelMuted: Color(0xFF9CA3AF),
  );

  /// Soft charcoal, not pure black: layered greys so cards lift off the
  /// page, a calmer coral, and white on coral like the light theme.
  factory AppColors.dark() => const AppColors(
    primary: Color(0xFFE8654B),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF7AA7F7),
    onSecondary: Color(0xFF121316),
    background: Color(0xFF121316),
    surface: Color(0xFF1B1D21),
    surfaceAlt: Color(0xFF24272C),
    border: Color(0xFF2E3238),
    textPrimary: Color(0xFFECEDEF),
    textSecondary: Color(0xFF9EA3AB),
    success: Color(0xFF4CC38A),
    warning: Color(0xFFE8B04B),
    danger: Color(0xFFEF6B5B),
    onDanger: Color(0xFFFFFFFF),
    info: Color(0xFF7AA7F7),
    neutral: Color(0xFF9EA3AB),
    heroStart: Color(0xFF24272C),
    heroEnd: Color(0xFF1B1D21),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xFF9EA3AB),
    panel: Color(0xFF22252A),
    onPanel: Color(0xFFF5F6F7),
    onPanelMuted: Color(0xFF9EA3AB),
  );

  final Color primary, onPrimary, secondary, onSecondary;
  final Color background, surface, surfaceAlt, border;
  final Color textPrimary, textSecondary;
  final Color success, warning, danger, onDanger, info, neutral;
  final Color heroStart, heroEnd, onHero, onHeroMuted;

  /// A deep card that stays dark in both themes (Home's outstanding total).
  final Color panel, onPanel, onPanelMuted;

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
    Color? panel,
    Color? onPanel,
    Color? onPanelMuted,
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
    panel: panel ?? this.panel,
    onPanel: onPanel ?? this.onPanel,
    onPanelMuted: onPanelMuted ?? this.onPanelMuted,
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
      panel: mix(panel, other.panel),
      onPanel: mix(onPanel, other.onPanel),
      onPanelMuted: mix(onPanelMuted, other.onPanelMuted),
    );
  }
}

extension AppThemeX on BuildContext {
  AppColors get appColors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light();
  TextTheme get textStyles => Theme.of(this).textTheme;
}
