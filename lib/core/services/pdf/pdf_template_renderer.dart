import 'dart:convert';

import 'brand_swatch.dart';
import 'models/pdf_document.dart';
import 'pdf_page_size.dart';
import 'pdf_palette.dart';
import 'pdf_template.dart';
import 'templates/atelier_template.dart';
import 'templates/classic_template.dart';
import 'templates/compact_template.dart';
import 'templates/editorial_template.dart';
import 'templates/executive_template.dart';
import 'templates/folio_template.dart';
import 'templates/ledger_template.dart';
import 'templates/lumen_template.dart';
import 'templates/minimal_template.dart';
import 'templates/modern_template.dart';
import 'templates/nordic_template.dart';
import 'templates/studio_template.dart';

/// Turns a [PdfDocument] into HTML with the chosen template and accent color.
abstract final class PdfTemplateRenderer {
  static String render(
    PdfTemplate template,
    PdfDocument doc, {
    required String fontsCss,
    PdfPageSize size = PdfPageSize.a4,
    String? footer,
    String? accentColor,
  }) {
    final hex = accentColor ?? BrandSwatch.coral.hex;
    final soft = BrandSwatch.softFor(hex);

    final html = switch (template) {
      PdfTemplate.classic => ClassicTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.modern => ModernTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.minimal => MinimalTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.executive => ExecutiveTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.studio => StudioTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.editorial => EditorialTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.compact => CompactTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.ledger => LedgerTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.nordic => NordicTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.folio => FolioTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.atelier => AtelierTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
      PdfTemplate.lumen => LumenTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
        accentColor: hex,
        accentSoftColor: soft,
      ),
    };
    final line = footer?.trim();
    if (line == null || line.isEmpty) return html;
    final safe = const HtmlEscape().convert(line);
    return html.replaceFirst(
      '</body>',
      '<p style="margin:8mm 0 0;font-size:8pt;text-align:center;'
          'color:${PdfPalette.muted}">$safe</p></body>',
    );
  }
}
