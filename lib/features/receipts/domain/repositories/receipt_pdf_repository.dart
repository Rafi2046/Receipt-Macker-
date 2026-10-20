import '../../../../core/errors/result.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';

/// Makes the PDF of one payment receipt.
abstract interface class ReceiptPdfRepository {
  Future<Result<RenderedPdf>> render(
    String paymentId, {
    required PdfTemplate template,
    required String languageCode,
  });

  Future<Result<void>> printWithSystemDialog(
    String paymentId, {
    required PdfTemplate template,
    required String languageCode,
  });
}
