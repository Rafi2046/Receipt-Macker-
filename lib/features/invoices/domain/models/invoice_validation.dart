import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/validation_error.dart';
import 'invoice_field.dart';
import 'line_field.dart';

part 'invoice_validation.freezed.dart';

/// Errors for an invoice and each of its lines (keyed by line id).
@freezed
abstract class InvoiceValidation with _$InvoiceValidation {
  const factory InvoiceValidation({
    @Default({}) Map<InvoiceField, ValidationError> fields,
    @Default({}) Map<String, Map<LineField, ValidationError>> lines,
  }) = _InvoiceValidation;

  const InvoiceValidation._();

  bool get isValid => fields.isEmpty && lines.isEmpty;

  Map<LineField, ValidationError> forLine(String lineId) =>
      lines[lineId] ?? const {};
}
