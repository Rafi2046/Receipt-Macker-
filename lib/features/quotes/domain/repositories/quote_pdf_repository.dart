import '../../../../core/errors/result.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';

/// Makes the PDF of a quote (same templates as invoices, title = Quote).
abstract interface class QuotePdfRepository {
  Future<Result<RenderedPdf>> render(
    String quoteId, {
    required PdfTemplate template,
    required String languageCode,
    bool showBranding = false,
    String? accentColor,
  });

  Future<Result<void>> printWithSystemDialog(
    String quoteId, {
    required PdfTemplate template,
    required String languageCode,
    bool showBranding = false,
    String? accentColor,
  });
}
