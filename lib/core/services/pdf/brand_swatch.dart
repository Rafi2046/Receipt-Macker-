/// Curated brand accent colors for PDF invoice and receipt templates.
class BrandSwatch {
  const BrandSwatch({
    required this.id,
    required this.name,
    required this.hex,
    required this.softHex,
  });

  final String id;
  final String name;
  final String hex;
  final String softHex;

  /// Flagship brand color (Radiant Coral / QuickBill primary).
  static const BrandSwatch coral = BrandSwatch(
    id: 'coral',
    name: 'Coral',
    hex: '#FF5738',
    softHex: '#FFF1EE',
  );

  /// Emerald swatch.
  static const BrandSwatch emerald = BrandSwatch(
    id: 'emerald',
    name: 'Emerald',
    hex: '#006A4E',
    softHex: '#E6F2EE',
  );

  static const BrandSwatch navy = BrandSwatch(
    id: 'navy',
    name: 'Navy',
    hex: '#1E3A8A',
    softHex: '#EFF6FF',
  );

  static const BrandSwatch crimson = BrandSwatch(
    id: 'crimson',
    name: 'Crimson',
    hex: '#991B1B',
    softHex: '#FEF2F2',
  );

  static const BrandSwatch slate = BrandSwatch(
    id: 'slate',
    name: 'Slate',
    hex: '#334155',
    softHex: '#F1F5F9',
  );

  static const BrandSwatch amber = BrandSwatch(
    id: 'amber',
    name: 'Amber',
    hex: '#D97706',
    softHex: '#FFFBEB',
  );

  static const BrandSwatch teal = BrandSwatch(
    id: 'teal',
    name: 'Teal',
    hex: '#0F766E',
    softHex: '#F0FDFA',
  );

  static const BrandSwatch indigo = BrandSwatch(
    id: 'indigo',
    name: 'Indigo',
    hex: '#4338CA',
    softHex: '#EEF2FF',
  );

  static const BrandSwatch charcoal = BrandSwatch(
    id: 'charcoal',
    name: 'Charcoal',
    hex: '#18181B',
    softHex: '#F4F4F5',
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
  ];

  static BrandSwatch fromHex(String? hex) {
    if (hex == null || hex.isEmpty) return coral;
    final normalized = hex.trim().toLowerCase();
    return values.firstWhere(
      (s) => s.hex.toLowerCase() == normalized,
      orElse: () => coral,
    );
  }

  static String softFor(String? hex) {
    if (hex == null || hex.isEmpty) return coral.softHex;
    final match = fromHex(hex);
    if (match.hex.toLowerCase() == hex.trim().toLowerCase()) {
      return match.softHex;
    }
    return '${hex.trim()}15';
  }
}
