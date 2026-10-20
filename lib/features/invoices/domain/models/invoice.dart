import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/calendar_date.dart';
import 'bill_to.dart';
import 'discount.dart';
import 'invoice_stage.dart';
import 'line_item.dart';

part 'invoice.freezed.dart';

/// An invoice. Money is integer minor units of [currencyCode]; the tax rate
/// is in basis points (1500 = 15%). Totals come from `InvoiceCalculator`.
@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String number,
    required String currencyCode,
    required CalendarDate issueDate,
    required CalendarDate dueDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(InvoiceStage.draft) InvoiceStage stage,

    /// The saved client picked for this invoice (null if deleted or none).
    String? clientId,
    BillTo? billTo,
    @Default([]) List<LineItem> lines,
    Discount? discount,

    /// Null means no tax.
    int? taxRateBasisPoints,

    /// True when prices already include the tax.
    @Default(false) bool taxInclusive,

    /// Shipping or another extra charge, added after tax.
    @Default(0) int shippingMinor,

    /// Sum of recorded payments, in minor units. The calculator turns this
    /// into the balance. A duplicate starts at zero.
    @Default(0) int paidMinor,
    @Default('') String notes,
    @Default('') String terms,
    @Default('') String paymentInstructions,
  }) = _Invoice;
}
