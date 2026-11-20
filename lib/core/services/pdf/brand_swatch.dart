/// Curated brand colors for PDF invoice and receipt templates. Each one
/// carries the tones a premium layout needs: a soft wash, a deep shade for
/// gradients and dark panels, and a contrasting pair for small highlights.
class BrandSwatch {
  const BrandSwatch(
    this.id,
    this.name,
    this.hex,
    this.softHex,
    this.deepHex,
    this.pairHex,
  );

  final String id;
  final String name;
  final String hex;
  final String softHex;
  final String deepHex;
  final String pairHex;

  /// Flagship brand color (Radiant Coral / QuickBill primary).
  static const coral = BrandSwatch(
    'coral',
    'Coral',
    '#FF5738',
    '#FFF1EE',
    '#B8321A',
    '#1F2937',
  );
  static const emerald = BrandSwatch(
    'emerald',
    'Emerald',
    '#006A4E',
    '#E6F2EE',
    '#00402F',
    '#E0A100',
  );
  static const navy = BrandSwatch(
    'navy',
    'Navy',
    '#1E3A8A',
    '#EFF6FF',
    '#0F1F4D',
    '#F59E0B',
  );
  static const crimson = BrandSwatch(
    'crimson',
    'Crimson',
    '#991B1B',
    '#FEF2F2',
    '#5F0F0F',
    '#D4A017',
  );
  static const slate = BrandSwatch(
    'slate',
    'Slate',
    '#334155',
    '#F1F5F9',
    '#0F172A',
    '#38BDF8',
  );
  static const amber = BrandSwatch(
    'amber',
    'Amber',
    '#D97706',
    '#FFFBEB',
    '#8A4B03',
    '#1F2937',
  );
  static const teal = BrandSwatch(
    'teal',
    'Teal',
    '#0F766E',
    '#F0FDFA',
    '#0A4A45',
    '#F59E0B',
  );
  static const indigo = BrandSwatch(
    'indigo',
    'Indigo',
    '#4338CA',
    '#EEF2FF',
    '#2A2380',
    '#FBBF24',
  );
  static const charcoal = BrandSwatch(
    'charcoal',
    'Charcoal',
    '#18181B',
    '#F4F4F5',
    '#000000',
    '#D4AF37',
  );

  /// Quiet warm grey for clean / premium catalogs.
  static const stone = BrandSwatch(
    'stone',
    'Stone',
    '#57534E',
    '#F5F5F4',
    '#292524',
    '#C2410C',
  );
  static const royal = BrandSwatch(
    'royal',
    'Royal',
    '#1D4ED8',
    '#EFF6FF',
    '#1E3A8A',
    '#F59E0B',
  );
  static const forest = BrandSwatch(
    'forest',
    'Forest',
    '#14532D',
    '#F0FDF4',
    '#052E16',
    '#CA8A04',
  );
  static const wine = BrandSwatch(
    'wine',
    'Wine',
    '#7F1D4E',
    '#FDF2F8',
    '#4A0E2C',
    '#D4AF37',
  );
  static const plum = BrandSwatch(
    'plum',
    'Plum',
    '#6B21A8',
    '#FAF5FF',
    '#3B0764',
    '#F59E0B',
  );
  static const rose = BrandSwatch(
    'rose',
    'Rose',
    '#BE185D',
    '#FFF1F2',
    '#831843',
    '#1F2937',
  );
  static const ocean = BrandSwatch(
    'ocean',
    'Ocean',
    '#0369A1',
    '#F0F9FF',
    '#0C4A6E',
    '#F97316',
  );
  static const bronze = BrandSwatch(
    'bronze',
    'Bronze',
    '#92400E',
    '#FFF7ED',
    '#5A2706',
    '#1F2937',
  );
  static const midnight = BrandSwatch(
    'midnight',
    'Midnight',
    '#0F172A',
    '#F1F5F9',
    '#020617',
    '#E0A100',
  );
  static const olive = BrandSwatch(
    'olive',
    'Olive',
    '#4D5B1E',
    '#F7F9EC',
    '#2C350F',
    '#C2410C',
  );
  static const violet = BrandSwatch(
    'violet',
    'Violet',
    '#7C3AED',
    '#F5F3FF',
    '#4C1D95',
    '#FBBF24',
  );

  static const List<BrandSwatch> values = [
    coral,
    navy,
    emerald,
    crimson,
    slate,
    amber,
    teal,
    indigo,
    charcoal,
    stone,
    royal,
    forest,
    wine,
    plum,
    rose,
    ocean,
    bronze,
    midnight,
    olive,
    violet,
  ];

  /// Highlight used with a color that is not one of ours.
  static const String fallbackPairHex = '#E0A100';

  static BrandSwatch? _exact(String? hex) {
    if (hex == null || hex.isEmpty) return coral;
    final normalized = hex.trim().toLowerCase();
    for (final s in values) {
      if (s.hex.toLowerCase() == normalized) return s;
    }
    return null;
  }

  static BrandSwatch fromHex(String? hex) => _exact(hex) ?? coral;

  static String softFor(String? hex) =>
      _exact(hex)?.softHex ?? '${(hex ?? '').trim()}15';

  /// A darker shade of [hex]: ours when known, else 40% toward black.
  static String deepFor(String? hex) =>
      _exact(hex)?.deepHex ?? _darken((hex ?? '').trim());

  static String pairFor(String? hex) => _exact(hex)?.pairHex ?? fallbackPairHex;

  static String _darken(String hex) {
    final value = int.tryParse(hex.replaceAll('#', ''), radix: 16);
    if (value == null || hex.replaceAll('#', '').length != 6) return hex;
    int tone(int shift) => (((value >> shift) & 0xFF) * 0.6).round();
    final rgb = (tone(16) << 16) | (tone(8) << 8) | tone(0);
    return '#${rgb.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}
