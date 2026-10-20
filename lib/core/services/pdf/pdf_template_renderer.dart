import 'models/pdf_document.dart';
import 'pdf_page_size.dart';
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
  }) => switch (template) {
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
}
