import '../../../../core/errors/result.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';

/// Makes the PDF of an invoice. Fails with `PdfFailure` when the PDF could
/// not be made.
abstract interface class InvoicePdfRepository {
  /// [languageCode] (`en`/`bn`) sets labels, digits and dates in the PDF.
  Future<Result<RenderedPdf>> render(
    String invoiceId, {
    required PdfTemplate template,
    required String languageCode,
  });

  /// Fallback when [render] fails: the system print dialog, which can also
  /// save as PDF.
  Future<Result<void>> printWithSystemDialog(
    String invoiceId, {
    required PdfTemplate template,
    required String languageCode,
  });
}
