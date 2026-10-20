import 'package:freezed_annotation/freezed_annotation.dart';

part 'pdf_field.freezed.dart';

/// A label and its value, already localized and formatted
/// (e.g. "Due date" / "২৭ অক্টো, ২০২৬").
@freezed
abstract class PdfField with _$PdfField {
  const factory PdfField({required String label, required String value}) =
      _PdfField;
}
