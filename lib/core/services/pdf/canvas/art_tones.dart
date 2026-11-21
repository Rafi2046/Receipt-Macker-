import '../brand_swatch.dart';
import 'art_shape.dart';

/// The hex colors a design's art is painted with, from one brand color.
class ArtTones {
  ArtTones(String accentHex)
    : accent = accentHex,
      deep = BrandSwatch.deepFor(accentHex),
      pair = BrandSwatch.pairFor(accentHex),
      soft = BrandSwatch.softFor(accentHex);

  final String accent;
  final String deep;
  final String pair;
  final String soft;

  /// A highlight that reads on a dark page: the pair color when it is
  /// light enough, else the pale wash of the brand color (light grey when
  /// the wash is see-through).
  String get highlight =>
      _luminance(pair) > 0.4 ? pair : (soft.length == 7 ? soft : '#F3F4F6');

  static double _luminance(String hex) {
    final v = int.tryParse(hex.replaceAll('#', ''), radix: 16) ?? 0;
    double c(int shift) => ((v >> shift) & 0xFF) / 255;
    return 0.2126 * c(16) + 0.7152 * c(8) + 0.0722 * c(0);
  }

  static const String paper = '#FFFFFF';
  static const String mist = '#E5E7EB';
  static const String ink = '#0B0F19';

  String hex(ArtTone tone) => switch (tone) {
    ArtTone.accent => accent,
    ArtTone.deep => deep,
    ArtTone.pair => pair,
    ArtTone.soft => soft,
    ArtTone.paper => paper,
    ArtTone.mist => mist,
    ArtTone.ink => ink,
  };
}
