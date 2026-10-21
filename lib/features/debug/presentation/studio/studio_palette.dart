import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';

/// Current-direction colors for the high-fidelity mock. Widgets read these
/// fields and do not pick their own colors.
class StudioPalette {
  const StudioPalette({
    required this.background,
    required this.surface,
    required this.ink,
    required this.muted,
    required this.line,
    required this.cardBorder,
    required this.accent,
    required this.onAccent,
    required this.gold,
    required this.goldInk,
    required this.paid,
    required this.partial,
    required this.overdue,
    required this.draft,
    required this.sent,
    required this.warningWash,
    required this.warningInk,
    required this.heroStart,
    required this.heroEnd,
    required this.onHero,
    required this.onHeroMuted,
    required this.heroGlow,
    required this.heroPill,
    required this.chartMuted,
    required this.cardShadows,
    required this.barShadows,
    required this.avatarBackgrounds,
    required this.avatarForegrounds,
  });

  final Color background;
  final Color surface;
  final Color ink;
  final Color muted;
  final Color line;
  final Color cardBorder;
  final Color accent;
  final Color onAccent;
  final Color gold;
  final Color goldInk;
  final Color paid;
  final Color partial;
  final Color overdue;
  final Color draft;
  final Color sent;
  final Color warningWash;
  final Color warningInk;
  final Color heroStart;
  final Color heroEnd;
  final Color onHero;
  final Color onHeroMuted;
  final Color heroGlow;
  final Color heroPill;
  final Color chartMuted;
  final List<BoxShadow> cardShadows;
  final List<BoxShadow> barShadows;
  final List<Color> avatarBackgrounds;
  final List<Color> avatarForegrounds;

  static const double cardRadius = AppSpacing.xl;
  static const double navRadius = AppSpacing.xxl;
  static const double chartHeight = 72;

  Color wash(Color color) => color.withValues(alpha: 0.12);

  Color avatarBackground(String name) =>
      avatarBackgrounds[_toneIndex(name, avatarBackgrounds.length)];

  Color avatarForeground(String name) =>
      avatarForegrounds[_toneIndex(name, avatarForegrounds.length)];

  static int _toneIndex(String name, int length) {
    var hash = 0;
    for (final unit in name.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return hash % length;
  }

  static StudioPalette of(Brightness brightness) =>
      brightness == Brightness.dark ? dark : light;

  static const StudioPalette light = StudioPalette(
    background: Color(0xFFF3F5F7),
    surface: Color(0xFFFFFFFF),
    ink: Color(0xFF101418),
    muted: Color(0xFF5C6770),
    line: Color(0xFFE6EBEF),
    cardBorder: Color(0xFFF3F5F7),
    accent: Color(0xFF006A4E),
    onAccent: Color(0xFFFFFFFF),
    gold: Color(0xFFE0A100),
    goldInk: Color(0xFF6E5200),
    paid: Color(0xFF157A45),
    partial: Color(0xFFB45309),
    overdue: Color(0xFFB42318),
    draft: Color(0xFF5C6770),
    sent: Color(0xFF1D4ED8),
    warningWash: Color(0xFFFFF6E8),
    warningInk: Color(0xFF8A5A12),
    heroStart: Color(0xFF0B5E48),
    heroEnd: Color(0xFF004233),
    onHero: Color(0xFFFFFFFF),
    onHeroMuted: Color(0xD6FFFFFF),
    heroGlow: Color(0x1FFFFFFF),
    heroPill: Color(0x29FFFFFF),
    chartMuted: Color(0xFFB7D4C8),
    cardShadows: [
      BoxShadow(color: Color(0x140C1B16), blurRadius: 18, offset: Offset(0, 8)),
    ],
    barShadows: [
      BoxShadow(color: Color(0x1F0C1B16), blurRadius: 24, offset: Offset(0, 8)),
    ],
    avatarBackgrounds: [
      Color(0xFFE5F4EE),
      Color(0xFFE8F0FE),
      Color(0xFFFFF3D6),
      Color(0xFFFDECEC),
      Color(0xFFF3EEF8),
    ],
    avatarForegrounds: [
      Color(0xFF006A4E),
      Color(0xFF1D4ED8),
      Color(0xFF8A5A12),
      Color(0xFF9F2D2D),
      Color(0xFF5B3F8C),
    ],
  );

  static const StudioPalette dark = StudioPalette(
    background: Color(0xFF0E1114),
    surface: Color(0xFF1A1F24),
    ink: Color(0xFFF2F5F7),
    muted: Color(0xFF9AA3AB),
    line: Color(0xFF2C343C),
    cardBorder: Color(0xFF2C343C),
    accent: Color(0xFF3DDC97),
    onAccent: Color(0xFF06281C),
    gold: Color(0xFFF5C542),
    goldInk: Color(0xFFF5C542),
    paid: Color(0xFF3DDC97),
    partial: Color(0xFFF5C542),
    overdue: Color(0xFFFF8A80),
    draft: Color(0xFF9AA3AB),
    sent: Color(0xFF8EB4FF),
    warningWash: Color(0xFF2A2418),
    warningInk: Color(0xFFF0C56A),
    heroStart: Color(0xFF146B52),
    heroEnd: Color(0xFF0B3B2E),
    onHero: Color(0xFFF4FFF9),
    onHeroMuted: Color(0xCCE7FFF4),
    heroGlow: Color(0x263DDC97),
    heroPill: Color(0x333DDC97),
    chartMuted: Color(0xFF1E3A30),
    cardShadows: [],
    barShadows: [
      BoxShadow(color: Color(0x66000000), blurRadius: 24, offset: Offset(0, 8)),
    ],
    avatarBackgrounds: [
      Color(0xFF14352C),
      Color(0xFF1A2744),
      Color(0xFF3A2E14),
      Color(0xFF3A1E1E),
      Color(0xFF2A2140),
    ],
    avatarForegrounds: [
      Color(0xFF8FCBB2),
      Color(0xFF8EB4FF),
      Color(0xFFF5C542),
      Color(0xFFFF8A80),
      Color(0xFFD2C4F0),
    ],
  );
}
