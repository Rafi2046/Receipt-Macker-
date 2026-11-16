import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/calendar_date.dart';
import '../../../invoices/domain/models/bill_to.dart';
import '../../../invoices/domain/models/discount.dart';
import '../../../invoices/domain/models/line_item.dart';
import 'quote_status.dart';

part 'quote.freezed.dart';

/// A price quote / estimate. Same money rules as invoices; no payments.
@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required String id,
    required String number,
    required String currencyCode,
    required CalendarDate issueDate,
    required CalendarDate validUntil,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(QuoteStatus.pending) QuoteStatus status,
    String? clientId,
    BillTo? billTo,
    @Default([]) List<LineItem> lines,
    Discount? discount,
    int? taxRateBasisPoints,
    @Default(false) bool taxInclusive,
    @Default(0) int shippingMinor,
    @Default('') String notes,
    @Default('') String terms,
    @Default('') String paymentInstructions,

    /// Set after convert-to-invoice.
    String? convertedInvoiceId,
  }) = _Quote;
}
