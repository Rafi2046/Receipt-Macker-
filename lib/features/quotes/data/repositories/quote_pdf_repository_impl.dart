import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Locale;

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/pdf/html_pdf_converter.dart';
import '../../../../core/services/pdf/models/pdf_document.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_fonts.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/pdf/pdf_template_renderer.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../../business_profile/business_profile.dart';
import '../../../invoices/data/mappers/invoice_pdf_mapper.dart';
import '../../../invoices/domain/logic/invoice_calculator.dart';
import '../../../invoices/domain/models/invoice.dart';
import '../../domain/logic/quote_to_invoice.dart';
import '../../domain/repositories/quote_pdf_repository.dart';
import '../../domain/repositories/quote_repository.dart';

class QuotePdfRepositoryImpl implements QuotePdfRepository {
  QuotePdfRepositoryImpl(
    this._quotes,
    this._profiles,
    this._converter,
    this._fonts,
    this._cacheDirectory,
  );

  final QuoteRepository _quotes;
  final BusinessProfileRepository _profiles;
  final HtmlPdfConverter _converter;
  final PdfFonts _fonts;
  final Future<Directory> Function() _cacheDirectory;

  static const String _folder = 'pdf';

  static Failure _pdf(Object e, StackTrace s) =>
      e is Failure ? e : PdfFailure(cause: e, stackTrace: s);

  @override
  Future<Result<RenderedPdf>> render(
    String quoteId, {
    required PdfTemplate template,
    required String languageCode,
    bool showBranding = false,
    String? accentColor,
  }) => Result.guard(() async {
    final (invoice, html) = await _html(
      quoteId,
      template,
      languageCode,
      showBranding: showBranding,
      accentColor: accentColor,
    );
    final fileName = _fileNameFor(invoice.number);
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
    String quoteId, {
    required PdfTemplate template,
    required String languageCode,
    bool showBranding = false,
    String? accentColor,
  }) => Result.guard(() async {
    final (invoice, html) = await _html(
      quoteId,
      template,
      languageCode,
      showBranding: showBranding,
      accentColor: accentColor,
    );
    await _converter.printWithSystemDialog(html: html, jobName: invoice.number);
  }, onError: _pdf);

  static String _fileNameFor(String number) {
    final safe = number.trim().replaceAll(RegExp(r'[\\/:*?"<>|\s]+'), '_');
    return '${safe.isEmpty ? 'quote' : safe}.pdf';
  }

  Future<(Invoice, String)> _html(
    String quoteId,
    PdfTemplate template,
    String languageCode, {
    required bool showBranding,
    String? accentColor,
  }) async {
    final quote = _value(await _quotes.find(quoteId));
    final profile = _value(await _profiles.load());
    if (profile == null) throw const NotFoundFailure();
    final invoice = QuoteToInvoice.asInvoice(quote);
    final l10n = lookupAppLocalizations(Locale(languageCode));
    final doc = await _document(invoice, profile, languageCode, l10n.pdfQuoteTitle);
    final html = PdfTemplateRenderer.render(
      template,
      doc,
      fontsCss: await _fonts.css(),
      footer: showBranding ? l10n.pdfMadeWith : null,
      accentColor: accentColor,
    );
    return (invoice, html);
  }

  Future<PdfDocument> _document(
    Invoice invoice,
    BusinessProfile profile,
    String languageCode,
    String documentTitle,
  ) async =>
      InvoicePdfMapper(
        lookupAppLocalizations(Locale(languageCode)),
        AppFormatters(languageCode),
      ).map(
        invoice: invoice,
        totals: InvoiceCalculator.calculate(invoice),
        seller: profile,
        logoDataUri: await _dataUri(profile.logoPath),
        signatureDataUri: await _dataUri(profile.signaturePath),
        documentTitle: documentTitle,
      );

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
