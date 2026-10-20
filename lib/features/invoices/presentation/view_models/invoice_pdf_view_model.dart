import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/clock.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/service_providers.dart';
import '../../domain/models/invoice_stage.dart';
import '../../providers.dart';
import 'invoice_pdf_state.dart';

part 'invoice_pdf_view_model.g.dart';

/// Makes, previews and hands out the PDF of one invoice. The template is
/// remembered; the language starts as the app's.
@riverpod
class InvoicePdfViewModel extends _$InvoicePdfViewModel {
  static const String _fallbackLanguage = 'en';

  @override
  InvoicePdfState build(String invoiceId) {
    final prefs = ref.read(appPreferencesProvider);
    final language = prefs.languageCode ?? _fallbackLanguage;
    scheduleMicrotask(render);
    return InvoicePdfState(
      template: PdfTemplate.fromId(prefs.pdfTemplate),
      languageCode: language,
    );
  }

  /// (Re)makes the PDF with the current template and language.
  Future<void> render() async {
    state = state.copyWith(isRendering: true, renderFailure: null);
    final s = state;
    final result = await ref
        .read(invoicePdfRepositoryProvider)
        .render(invoiceId, template: s.template, languageCode: s.languageCode);
    if (!ref.mounted) return;
    switch (result) {
      case Ok(:final value):
        try {
          final pages = await ref
              .read(pdfRasterServiceProvider)
              .pages(value.bytes);
          if (!ref.mounted) return;
          state = state.copyWith(pdf: value, pages: pages, isRendering: false);
        } on Object catch (e, st) {
          if (!ref.mounted) return;
          state = state.copyWith(
            isRendering: false,
            renderFailure: PdfFailure(cause: e, stackTrace: st),
          );
        }
      case Err(:final failure):
        state = state.copyWith(isRendering: false, renderFailure: failure);
    }
  }

  Future<void> setTemplate(PdfTemplate template) async {
    if (template == state.template) return;
    state = state.copyWith(template: template);
    await ref.read(appPreferencesProvider).setPdfTemplate(template.id);
    await render();
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode == state.languageCode) return;
    state = state.copyWith(languageCode: languageCode);
    await render();
  }

  /// Opens the share sheet. Returns true when the invoice is still a draft
  /// after sharing, so the view can offer "Mark as sent".
  Future<bool> share({required String subject}) => _act((pdf) async {
    final shared = await ref
        .read(shareServiceProvider)
        .shareFile(pdf.path, mimeType: RenderedPdf.mimeType, subject: subject);
    if (!shared) return false;
    final invoice = await ref.read(invoiceRepositoryProvider).find(invoiceId);
    return invoice.valueOrNull?.stage == InvoiceStage.draft;
  });

  Future<bool> print() => _act(
    (pdf) =>
        ref.read(pdfPrintServiceProvider).print(pdf.bytes, name: pdf.fileName),
  );

  /// Returns true when saved (false when cancelled).
  Future<bool> save() => _act(
    (pdf) => ref
        .read(fileSaveServiceProvider)
        .save(
          fileName: pdf.fileName,
          bytes: pdf.bytes,
          mimeType: RenderedPdf.mimeType,
        ),
  );

  /// Fallback when making the PDF failed: the system print dialog.
  Future<void> printWithSystemDialog() async {
    final s = state;
    final result = await ref
        .read(invoicePdfRepositoryProvider)
        .printWithSystemDialog(
          invoiceId,
          template: s.template,
          languageCode: s.languageCode,
        );
    if (result case Err(:final failure) when ref.mounted) {
      state = state.copyWith(actionFailure: failure);
    }
  }

  Future<Result<void>> markSent() async {
    final repo = ref.read(invoiceRepositoryProvider);
    final found = await repo.find(invoiceId);
    final invoice = found.valueOrNull;
    if (invoice == null) return const Err(NotFoundFailure());
    final now = ref.read(clockProvider)();
    final saved = await repo.save(
      invoice.copyWith(stage: InvoiceStage.sent, updatedAt: now),
    );
    return saved.isOk ? const Ok(null) : const Err(DatabaseFailure());
  }

  void clearActionFailure() => state = state.copyWith(actionFailure: null);

  Future<bool> _act(Future<bool> Function(RenderedPdf pdf) action) async {
    final pdf = state.pdf;
    if (pdf == null || state.isBusy) return false;
    state = state.copyWith(isBusy: true);
    try {
      return await action(pdf);
    } on Object catch (e, st) {
      if (ref.mounted) {
        state = state.copyWith(
          actionFailure: PdfFailure(cause: e, stackTrace: st),
        );
      }
      return false;
    } finally {
      if (ref.mounted) state = state.copyWith(isBusy: false);
    }
  }
}
