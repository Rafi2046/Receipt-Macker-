import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_numbering.freezed.dart';

/// Prefix and sequence for auto-generating invoice numbers (e.g. `INV-` and 1).
@freezed
abstract class InvoiceNumbering with _$InvoiceNumbering {
  const factory InvoiceNumbering({
    required String prefix,
    required int nextSequence,
  }) = _InvoiceNumbering;
}
