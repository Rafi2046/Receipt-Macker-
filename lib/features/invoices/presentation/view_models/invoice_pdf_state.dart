import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';

part 'invoice_pdf_state.freezed.dart';

@freezed
abstract class InvoicePdfState with _$InvoicePdfState {
  const factory InvoicePdfState({
    required PdfTemplate template,

    /// `en` or `bn`: the PDF's language, independent of the app's.
    required String languageCode,
    RenderedPdf? pdf,

    /// The pages as PNG images for the preview.
    @Default([]) List<Uint8List> pages,
    @Default(true) bool isRendering,

    /// Share, print or save in progress.
    @Default(false) bool isBusy,

    /// Why the PDF could not be made; shown with Retry and the print
    /// dialog fallback.
    Failure? renderFailure,

    /// A failed share, print or save; shown once, then cleared.
    Failure? actionFailure,
  }) = _InvoicePdfState;

  const InvoicePdfState._();

  bool get isReady => pdf != null && !isRendering;
}
