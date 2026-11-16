import 'pdf_template.dart';
import 'pdf_template_catalog_entry.dart';
import 'pdf_template_category.dart';

/// Curated layout × swatch gallery. Not a full cartesian product.
abstract final class PdfTemplateCatalog {
  static const List<PdfTemplateCatalogEntry> entries = [
    // Recommend
    PdfTemplateCatalogEntry(
      id: 'classic_coral',
      layout: PdfTemplate.classic,
      accentHex: '#FF5738',
      category: PdfTemplateCategory.recommend,
      requiresPro: false,
    ),
    PdfTemplateCatalogEntry(
      id: 'modern_navy',
      layout: PdfTemplate.modern,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'executive_emerald',
      layout: PdfTemplate.executive,
      accentHex: '#006A4E',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'studio_indigo',
      layout: PdfTemplate.studio,
      accentHex: '#4338CA',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'minimal_slate',
      layout: PdfTemplate.minimal,
      accentHex: '#334155',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'ledger_charcoal',
      layout: PdfTemplate.ledger,
      accentHex: '#18181B',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'editorial_crimson',
      layout: PdfTemplate.editorial,
      accentHex: '#991B1B',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'compact_teal',
      layout: PdfTemplate.compact,
      accentHex: '#0F766E',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'nordic_slate',
      layout: PdfTemplate.nordic,
      accentHex: '#334155',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'folio_charcoal',
      layout: PdfTemplate.folio,
      accentHex: '#18181B',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'atelier_stone',
      layout: PdfTemplate.atelier,
      accentHex: '#57534E',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'lumen_navy',
      layout: PdfTemplate.lumen,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.recommend,
      requiresPro: true,
    ),

    // Simple
    PdfTemplateCatalogEntry(
      id: 'minimal_coral',
      layout: PdfTemplate.minimal,
      accentHex: '#FF5738',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'minimal_navy',
      layout: PdfTemplate.minimal,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'minimal_emerald',
      layout: PdfTemplate.minimal,
      accentHex: '#006A4E',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'compact_coral',
      layout: PdfTemplate.compact,
      accentHex: '#FF5738',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'compact_navy',
      layout: PdfTemplate.compact,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'compact_slate',
      layout: PdfTemplate.compact,
      accentHex: '#334155',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'classic_slate',
      layout: PdfTemplate.classic,
      accentHex: '#334155',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'nordic_charcoal',
      layout: PdfTemplate.nordic,
      accentHex: '#18181B',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'nordic_stone',
      layout: PdfTemplate.nordic,
      accentHex: '#57534E',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'folio_slate',
      layout: PdfTemplate.folio,
      accentHex: '#334155',
      category: PdfTemplateCategory.simple,
      requiresPro: true,
    ),

    // Classic
    PdfTemplateCatalogEntry(
      id: 'classic_navy',
      layout: PdfTemplate.classic,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.classic,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'classic_emerald',
      layout: PdfTemplate.classic,
      accentHex: '#006A4E',
      category: PdfTemplateCategory.classic,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'classic_charcoal',
      layout: PdfTemplate.classic,
      accentHex: '#18181B',
      category: PdfTemplateCategory.classic,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'classic_amber',
      layout: PdfTemplate.classic,
      accentHex: '#D97706',
      category: PdfTemplateCategory.classic,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'ledger_navy',
      layout: PdfTemplate.ledger,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.classic,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'ledger_emerald',
      layout: PdfTemplate.ledger,
      accentHex: '#006A4E',
      category: PdfTemplateCategory.classic,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'ledger_coral',
      layout: PdfTemplate.ledger,
      accentHex: '#FF5738',
      category: PdfTemplateCategory.classic,
      requiresPro: true,
    ),

    // Professional
    PdfTemplateCatalogEntry(
      id: 'executive_navy',
      layout: PdfTemplate.executive,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'executive_charcoal',
      layout: PdfTemplate.executive,
      accentHex: '#18181B',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'executive_coral',
      layout: PdfTemplate.executive,
      accentHex: '#FF5738',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'executive_indigo',
      layout: PdfTemplate.executive,
      accentHex: '#4338CA',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'studio_navy',
      layout: PdfTemplate.studio,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'studio_emerald',
      layout: PdfTemplate.studio,
      accentHex: '#006A4E',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'studio_coral',
      layout: PdfTemplate.studio,
      accentHex: '#FF5738',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'studio_charcoal',
      layout: PdfTemplate.studio,
      accentHex: '#18181B',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'folio_navy',
      layout: PdfTemplate.folio,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'lumen_slate',
      layout: PdfTemplate.lumen,
      accentHex: '#334155',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'lumen_emerald',
      layout: PdfTemplate.lumen,
      accentHex: '#006A4E',
      category: PdfTemplateCategory.professional,
      requiresPro: true,
    ),

    // Modern
    PdfTemplateCatalogEntry(
      id: 'modern_coral',
      layout: PdfTemplate.modern,
      accentHex: '#FF5738',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'modern_teal',
      layout: PdfTemplate.modern,
      accentHex: '#0F766E',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'modern_crimson',
      layout: PdfTemplate.modern,
      accentHex: '#991B1B',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'modern_indigo',
      layout: PdfTemplate.modern,
      accentHex: '#4338CA',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'editorial_navy',
      layout: PdfTemplate.editorial,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'editorial_teal',
      layout: PdfTemplate.editorial,
      accentHex: '#0F766E',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'editorial_amber',
      layout: PdfTemplate.editorial,
      accentHex: '#D97706',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'editorial_coral',
      layout: PdfTemplate.editorial,
      accentHex: '#FF5738',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'atelier_navy',
      layout: PdfTemplate.atelier,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'atelier_teal',
      layout: PdfTemplate.atelier,
      accentHex: '#0F766E',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'lumen_stone',
      layout: PdfTemplate.lumen,
      accentHex: '#57534E',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
    PdfTemplateCatalogEntry(
      id: 'nordic_navy',
      layout: PdfTemplate.nordic,
      accentHex: '#1E3A8A',
      category: PdfTemplateCategory.modern,
      requiresPro: true,
    ),
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
    return entries.first;
  }
}
