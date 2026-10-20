import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf_line.freezed.dart';

/// One table row, every value already formatted for the PDF's language.
@freezed
abstract class PdfLine with _$PdfLine {
  const factory PdfLine({
    required String name,
    required String quantity,
    required String unitPrice,
    required String amount,
    @Default('') String description,

    /// e.g. "Less 10%", shown under the amount.
    String? discountNote,
  }) = _PdfLine;
}
