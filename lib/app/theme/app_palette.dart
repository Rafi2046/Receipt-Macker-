import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../../features/settings/domain/models/app_palette_id.dart';

/// Brand colors for one palette, in light and dark variants.
@immutable
class AppPalette {
  const AppPalette({
    required this.id,
    required this.lightPrimary,
    required this.lightOnPrimary,
    required this.lightSecondary,
    required this.lightOnSecondary,
    required this.darkPrimary,
    required this.darkOnPrimary,
    required this.darkSecondary,
    required this.darkOnSecondary,
  });

  final AppPaletteId id;
  final Color lightPrimary, lightOnPrimary, lightSecondary, lightOnSecondary;
  final Color darkPrimary, darkOnPrimary, darkSecondary, darkOnSecondary;

  /// Teal + amber: calm, trustworthy, money-friendly.
  static const AppPalette teal = AppPalette(
    id: AppPaletteId.teal,
    lightPrimary: Color(0xFF0F766E),
    lightOnPrimary: Color(0xFFFFFFFF),
    lightSecondary: Color(0xFFF59E0B),
    lightOnSecondary: Color(0xFF1F1300),
    darkPrimary: Color(0xFF2DD4BF),
    darkOnPrimary: Color(0xFF00201C),
    darkSecondary: Color(0xFFFBBF24),
    darkOnSecondary: Color(0xFF261A00),
  );

  /// Indigo + emerald: classic business / fintech.
  static const AppPalette indigo = AppPalette(
    id: AppPaletteId.indigo,
    lightPrimary: Color(0xFF4338CA),
    lightOnPrimary: Color(0xFFFFFFFF),
    lightSecondary: Color(0xFF047857),
    lightOnSecondary: Color(0xFFFFFFFF),
    darkPrimary: Color(0xFFA5B4FC),
    darkOnPrimary: Color(0xFF0F1452),
    darkSecondary: Color(0xFF6EE7B7),
    darkOnSecondary: Color(0xFF00291C),
  );

  /// Bottle green + gold: a nod to Bangladesh, distinct on the Play Store.
  static const AppPalette green = AppPalette(
    id: AppPaletteId.green,
    lightPrimary: Color(0xFF006A4E),
    lightOnPrimary: Color(0xFFFFFFFF),
    lightSecondary: Color(0xFFE0A100),
    lightOnSecondary: Color(0xFF241A00),
    darkPrimary: Color(0xFF4CC9A0),
    darkOnPrimary: Color(0xFF002116),
    darkSecondary: Color(0xFFF5C542),
    darkOnSecondary: Color(0xFF241A00),
  );

  static AppPalette of(AppPaletteId id) => switch (id) {
    AppPaletteId.teal => teal,
    AppPaletteId.indigo => indigo,
    AppPaletteId.green => green,
  };
}
