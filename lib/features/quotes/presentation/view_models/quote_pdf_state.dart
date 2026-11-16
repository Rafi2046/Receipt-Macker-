import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/pdf/models/rendered_pdf.dart';
import '../../../../core/services/pdf/pdf_template.dart';

part 'quote_pdf_state.freezed.dart';

@freezed
abstract class QuotePdfState with _$QuotePdfState {
  const factory QuotePdfState({
    required PdfTemplate template,
    required String languageCode,
    String? brandAccentColor,
    RenderedPdf? pdf,
    @Default([]) List<Uint8List> pages,
    @Default(true) bool isRendering,
    @Default(false) bool isBusy,
    Failure? renderFailure,
    Failure? actionFailure,
  }) = _QuotePdfState;

  const QuotePdfState._();

  bool get isReady => pdf != null && !isRendering;
}
