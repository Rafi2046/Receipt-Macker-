import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/brand_swatch.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template_catalog.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template_category.dart';

void main() {
  test('catalog has curated entries across every category', () {
    expect(PdfTemplateCatalog.entries.length, greaterThanOrEqualTo(100));
    for (final category in PdfTemplateCategory.values) {
      expect(
        PdfTemplateCatalog.byCategory(category),
        isNotEmpty,
        reason: '$category should have entries',
      );
    }
  });

  test('exactly ten designs are free, all on the free layouts', () {
    final free = PdfTemplateCatalog.entries.where((e) => !e.requiresPro);
    expect(free, hasLength(10));
    expect(free.first.id, 'classic_coral');
    for (final e in free) {
      expect(PdfTemplate.freeLayouts, contains(e.layout), reason: e.id);
    }
  });

  test('every layout is in the gallery and every color is ours', () {
    final layouts = PdfTemplateCatalog.entries.map((e) => e.layout).toSet();
    expect(layouts, PdfTemplate.values.toSet());
    for (final e in PdfTemplateCatalog.entries) {
      expect(e.swatch.hex, e.accentHex, reason: e.id);
    }
  });

  test('resolve matches layout and accent, else falls back by layout', () {
    final exact = PdfTemplateCatalog.resolve(
      layout: PdfTemplate.modern,
      accentHex: BrandSwatch.navy.hex,
    );
    expect(exact.id, 'modern_navy');

    final fallback = PdfTemplateCatalog.resolve(
      layout: PdfTemplate.classic,
      accentHex: '#00FF00',
    );
    expect(fallback.layout, PdfTemplate.classic);
  });

  test('findById returns null for unknown ids', () {
    expect(
      PdfTemplateCatalog.findById('classic_coral')?.layout,
      PdfTemplate.classic,
    );
    expect(PdfTemplateCatalog.findById('missing'), isNull);
  });

  test('entry ids are unique', () {
    final ids = PdfTemplateCatalog.entries.map((e) => e.id).toList();
    expect(ids.toSet().length, ids.length);
  });
}
