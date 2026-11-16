import 'brand_swatch.dart';
import 'pdf_template.dart';
import 'pdf_template_category.dart';

/// One selectable “template” in the gallery: a layout + accent combo.
///
/// PDF rendering still uses [layout] + [accentHex]; this layer only drives
/// browsing, Pro locks, and display names.
class PdfTemplateCatalogEntry {
  const PdfTemplateCatalogEntry({
    required this.id,
    required this.layout,
    required this.accentHex,
    required this.category,
    required this.requiresPro,
  });

  /// Stable id for analytics / matching selection (`classic_coral`).
  final String id;
  final PdfTemplate layout;
  final String accentHex;
  final PdfTemplateCategory category;

  /// True when this catalog card is Pro-only (layout or non-default accent).
  final bool requiresPro;

  BrandSwatch get swatch => BrandSwatch.fromHex(accentHex);

  bool matches({required PdfTemplate layout, required String? accentHex}) {
    final hex = (accentHex ?? BrandSwatch.coral.hex).toLowerCase();
    return this.layout == layout && this.accentHex.toLowerCase() == hex;
  }
}
