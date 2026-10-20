import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';

part 'receipt_pdf_state.freezed.dart';

@freezed
abstract class ReceiptPdfState with _$ReceiptPdfState {
  const factory ReceiptPdfState({
    required PdfTemplate template,
    required String languageCode,
    RenderedPdf? pdf,
    @Default([]) List<Uint8List> pages,
    @Default(true) bool isRendering,
    @Default(false) bool isBusy,
    Failure? renderFailure,
    Failure? actionFailure,
  }) = _ReceiptPdfState;

  const ReceiptPdfState._();

  bool get isReady => pdf != null && !isRendering;
}
