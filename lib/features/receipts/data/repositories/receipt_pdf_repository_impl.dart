import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/pdf/html_pdf_converter.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_fonts.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/pdf/pdf_template_renderer.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../business_profile/business_profile.dart';
import '../../../invoices/domain/logic/invoice_calculator.dart';
import '../../../invoices/domain/repositories/invoice_repository.dart';
import '../../../payments/domain/models/payment.dart';
import '../../../payments/domain/repositories/payment_repository.dart';
import '../../domain/logic/receipt_balance.dart';
import '../../domain/repositories/receipt_pdf_repository.dart';
import '../mappers/receipt_pdf_mapper.dart';

class ReceiptPdfRepositoryImpl implements ReceiptPdfRepository {
  ReceiptPdfRepositoryImpl(
    this._payments,
    this._invoices,
    this._profiles,
    this._converter,
    this._fonts,
    this._cacheDirectory,
  );

  final PaymentRepository _payments;
  final InvoiceRepository _invoices;
  final BusinessProfileRepository _profiles;
  final HtmlPdfConverter _converter;
  final PdfFonts _fonts;
  final Future<Directory> Function() _cacheDirectory;

  static const String _folder = 'pdf';

  static Failure _pdf(Object e, StackTrace s) =>
      e is Failure ? e : PdfFailure(cause: e, stackTrace: s);

  @override
  Future<Result<RenderedPdf>> render(
    String paymentId, {
    required PdfTemplate template,
    required String languageCode,
  }) => Result.guard(() async {
    final (payment, html) = await _html(paymentId, template, languageCode);
    final fileName = fileNameFor(payment.receiptNumber);
    final dir = await _cacheDirectory();
    final path = '${dir.path}/$_folder/$fileName';
    final pages = await _converter.toPdf(html: html, path: path);
    final bytes = await File(path).readAsBytes();
    return RenderedPdf(
      path: path,
      fileName: fileName,
      pageCount: pages,
      bytes: bytes,
    );
  }, onError: _pdf);

  @override
  Future<Result<void>> printWithSystemDialog(
    String paymentId, {
    required PdfTemplate template,
    required String languageCode,
  }) => Result.guard(() async {
    final (payment, html) = await _html(paymentId, template, languageCode);
    await _converter.printWithSystemDialog(
      html: html,
      jobName: payment.receiptNumber,
    );
  }, onError: _pdf);

  static String fileNameFor(String number) {
    final safe = number.trim().replaceAll(RegExp(r'[\\/:*?"<>|\s]+'), '_');
    return '${safe.isEmpty ? 'receipt' : safe}.pdf';
  }

  Future<(Payment, String)> _html(
    String paymentId,
    PdfTemplate template,
    String languageCode,
  ) async {
    final payment = _value(await _payments.find(paymentId));
    final invoice = _value(await _invoices.find(payment.invoiceId));
    final all = await _payments.watchForInvoice(payment.invoiceId).first;
    final profile = _value(await _profiles.load());
    if (profile == null) throw const NotFoundFailure();
    final balance = balanceAfterPayment(
      totalMinor: InvoiceCalculator.calculate(invoice).total,
      payments: all,
      paymentId: payment.id,
    );
    final doc =
        ReceiptPdfMapper(
          lookupAppLocalizations(Locale(languageCode)),
          AppFormatters(languageCode),
        ).map(
          payment: payment,
          invoice: invoice,
          balanceAfter: balance,
          seller: profile,
          logoDataUri: await _dataUri(profile.logoPath),
          signatureDataUri: await _dataUri(profile.signaturePath),
        );
    final html = PdfTemplateRenderer.render(
      template,
      doc,
      fontsCss: await _fonts.css(),
    );
    return (payment, html);
  }

  Future<String?> _dataUri(String? relativePath) async {
    if (relativePath == null) return null;
    final file = File(await _profiles.resolveImagePath(relativePath));
    if (!await file.exists()) return null;
    final ext = relativePath.split('.').last.toLowerCase();
    final mime = ext == 'png' ? 'image/png' : 'image/jpeg';
    return 'data:$mime;base64,${base64Encode(await file.readAsBytes())}';
  }

  static T _value<T>(Result<T> result) => switch (result) {
    Ok(:final value) => value,
    Err(:final failure) => throw failure,
  };
}
