import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/service_providers.dart';
import '../../providers.dart';
import 'receipt_pdf_state.dart';

part 'receipt_pdf_view_model.g.dart';

/// Makes, previews and hands out the receipt PDF of one payment.
@riverpod
class ReceiptPdfViewModel extends _$ReceiptPdfViewModel {
  static const String _fallbackLanguage = 'en';

  @override
  ReceiptPdfState build(String paymentId) {
    final prefs = ref.read(appPreferencesProvider);
    scheduleMicrotask(render);
    return ReceiptPdfState(
      template: PdfTemplate.fromId(prefs.pdfTemplate),
      languageCode: prefs.languageCode ?? _fallbackLanguage,
    );
  }

  Future<void> render() async {
    state = state.copyWith(isRendering: true, renderFailure: null);
    final s = state;
    final result = await ref
        .read(receiptPdfRepositoryProvider)
        .render(paymentId, template: s.template, languageCode: s.languageCode);
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

  Future<bool> share({required String subject}) => _act((pdf) async {
    return ref
        .read(shareServiceProvider)
        .shareFile(pdf.path, mimeType: RenderedPdf.mimeType, subject: subject);
  });

  Future<bool> print() => _act(
    (pdf) =>
        ref.read(pdfPrintServiceProvider).print(pdf.bytes, name: pdf.fileName),
  );

  Future<bool> save() => _act(
    (pdf) => ref
        .read(fileSaveServiceProvider)
        .save(
          fileName: pdf.fileName,
          bytes: pdf.bytes,
          mimeType: RenderedPdf.mimeType,
        ),
  );

  Future<void> printWithSystemDialog() async {
    final s = state;
    final result = await ref
        .read(receiptPdfRepositoryProvider)
        .printWithSystemDialog(
          paymentId,
          template: s.template,
          languageCode: s.languageCode,
        );
    if (result case Err(:final failure) when ref.mounted) {
      state = state.copyWith(actionFailure: failure);
    }
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
