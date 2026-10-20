import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf_party.freezed.dart';

/// The seller or the buyer: a name and contact lines.
@freezed
abstract class PdfParty with _$PdfParty {
  const factory PdfParty({
    required String name,
    @Default([]) List<String> lines,

    /// `data:` URI of the logo, if any.
    String? logoDataUri,
  }) = _PdfParty;
}
