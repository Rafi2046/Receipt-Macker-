import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/services/ads/ad_providers.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/purchases/free_plan.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
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
    var template = PdfTemplate.fromId(prefs.pdfTemplate);
    if (!FreePlan.canUse(template, isPro: prefs.isPro)) {
      template = PdfTemplate.classic;
    }
    scheduleMicrotask(render);
    return ReceiptPdfState(
      template: template,
      languageCode: prefs.languageCode ?? _fallbackLanguage,
    );
  }

  Future<void> render() async {
    state = state.copyWith(isRendering: true, renderFailure: null);
    final s = state;
    final result = await ref
        .read(receiptPdfRepositoryProvider)
        .render(
          paymentId,
          template: s.template,
          languageCode: s.languageCode,
          showBranding: _showBranding,
        );
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

  /// False when [template] is Pro and this account is free.
  Future<bool> setTemplate(PdfTemplate template) async {
    if (template == state.template) return true;
    if (!FreePlan.canUse(template, isPro: ref.read(proStatusProvider))) {
      return false;
    }
    state = state.copyWith(template: template);
    await ref.read(appPreferencesProvider).setPdfTemplate(template.id);
    await render();
    return true;
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode == state.languageCode) return;
    state = state.copyWith(languageCode: languageCode);
    await render();
  }

  Future<bool> share({required String subject}) => _act((pdf) async {
    final shared = await ref
        .read(shareServiceProvider)
        .shareFile(pdf.path, mimeType: RenderedPdf.mimeType, subject: subject);
    if (shared) await _countExport();
    return shared;
  });

  Future<bool> print() => _act(
    (pdf) =>
        ref.read(pdfPrintServiceProvider).print(pdf.bytes, name: pdf.fileName),
  );

  Future<bool> save() => _act((pdf) async {
    final saved = await ref
        .read(fileSaveServiceProvider)
        .save(
          fileName: pdf.fileName,
          bytes: pdf.bytes,
          mimeType: RenderedPdf.mimeType,
        );
    if (saved) await _countExport();
    return saved;
  });

  Future<void> printWithSystemDialog() async {
    final s = state;
    final result = await ref
        .read(receiptPdfRepositoryProvider)
        .printWithSystemDialog(
          paymentId,
          template: s.template,
          languageCode: s.languageCode,
          showBranding: _showBranding,
        );
    if (result case Err(:final failure) when ref.mounted) {
      state = state.copyWith(actionFailure: failure);
    }
  }

  bool get _showBranding =>
      FreePlan.showPdfFooter(isPro: ref.read(proStatusProvider));

  Future<void> _countExport() =>
      ref.read(exportAdGateProvider).afterSuccessfulExport();

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
