import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/brand_swatch.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template_catalog.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template_category.dart';

void main() {
  test('catalog has curated entries across every category', () {
    expect(PdfTemplateCatalog.entries.length, greaterThanOrEqualTo(30));
    expect(PdfTemplateCatalog.entries.length, lessThanOrEqualTo(64));
    for (final category in PdfTemplateCategory.values) {
      expect(
        PdfTemplateCatalog.byCategory(category),
        isNotEmpty,
        reason: '$category should have entries',
      );
    }
  });

  test('only classic_coral is free in the catalog', () {
    final free = PdfTemplateCatalog.entries.where((e) => !e.requiresPro);
    expect(free.map((e) => e.id), ['classic_coral']);
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
