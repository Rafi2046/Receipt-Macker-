import 'brand_swatch.dart';
import 'canvas/canvas_logo_picks.dart';
import 'canvas/canvas_picks.dart';
import 'pdf_template.dart';
import 'pdf_template_catalog_entry.dart';
import 'pdf_template_category.dart';
import 'pdf_template_picks.dart';

/// The design gallery: curated layout × color pairs, not a full cartesian
/// product. Each pair appears once, in the category it suits best; in each
/// tab the logo-header designs come first, then the other full-page art
/// designs. The ten designs on the free layouts are free; the rest are Pro.
abstract final class PdfTemplateCatalog {
  static final List<PdfTemplateCatalogEntry> entries = [
    for (final category in PdfTemplateCategory.values)
      for (final (layout, swatches) in [
        ..._layouts(CanvasLogoPicks.all, category),
        ..._layouts(CanvasPicks.all, category),
        ..._layouts(PdfTemplatePicks.all, category),
      ])
        for (final swatch in swatches)
          PdfTemplateCatalogEntry(
            id: '${layout.id}_${swatch.id}',
            layout: layout,
            accentHex: swatch.hex,
            category: category,
          ),
  ];

  static Iterable<(PdfTemplate, List<BrandSwatch>)> _layouts(
    List<(PdfTemplateCategory, List<(PdfTemplate, List<BrandSwatch>)>)> picks,
    PdfTemplateCategory category,
  ) => [
    for (final (c, layouts) in picks)
      if (c == category) ...layouts,
  ];

  static List<PdfTemplateCatalogEntry> byCategory(
    PdfTemplateCategory category,
  ) => entries.where((e) => e.category == category).toList(growable: false);

  static PdfTemplateCatalogEntry? findById(String id) {
    for (final e in entries) {
      if (e.id == id) return e;
    }
    return null;
  }

  static PdfTemplateCatalogEntry resolve({
    required PdfTemplate layout,
    required String? accentHex,
  }) {
    for (final e in entries) {
      if (e.matches(layout: layout, accentHex: accentHex)) return e;
    }
    for (final e in entries) {
      if (e.layout == layout) return e;
    }
    return entries.firstWhere((e) => !e.requiresPro);
  }
}
