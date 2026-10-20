import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_totals.freezed.dart';

/// Amounts for one line, in minor units.
@freezed
abstract class LineTotals with _$LineTotals {
  const factory LineTotals({
    /// Unit price × quantity.
    required int gross,
    required int discount,

    /// [gross] minus [discount].
    required int net,
  }) = _LineTotals;
}

/// Every amount on an invoice, in minor units of [currencyCode].
@freezed
abstract class InvoiceTotals with _$InvoiceTotals {
  const factory InvoiceTotals({
    required String currencyCode,
    required List<LineTotals> lines,

    /// Sum of line nets.
    required int subtotal,

    /// Invoice-level discount.
    required int discount,

    /// The tax amount (part of [taxableAmount] when tax is inclusive).
    required int tax,
    required int shipping,
    required int total,
    required int paid,

    /// [total] minus [paid]; negative when overpaid.
    required int balance,
  }) = _InvoiceTotals;

  const InvoiceTotals._();

  /// Subtotal after the invoice discount; the tax is worked out on this.
  int get taxableAmount => subtotal - discount;
}
