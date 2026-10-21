import 'dart:convert';

import 'models/pdf_document.dart';
import 'pdf_page_size.dart';
import 'pdf_palette.dart';
import 'pdf_template.dart';
import 'templates/classic_template.dart';
import 'templates/minimal_template.dart';
import 'templates/modern_template.dart';

/// Turns a [PdfDocument] into HTML with the chosen template.
abstract final class PdfTemplateRenderer {
  static String render(
    PdfTemplate template,
    PdfDocument doc, {
    required String fontsCss,
    PdfPageSize size = PdfPageSize.a4,
    String? footer,
  }) {
    final html = switch (template) {
      PdfTemplate.classic => ClassicTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
      ),
      PdfTemplate.modern => ModernTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
      ),
      PdfTemplate.minimal => MinimalTemplate.render(
        doc,
        fontsCss: fontsCss,
        size: size,
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
