import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/calendar_date.dart';
import 'payment_method.dart';

part 'payment.freezed.dart';

/// Money taken against one invoice. [amountMinor] is in that invoice's
/// currency. [receiptNumber] is empty until the payment is saved.
@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String invoiceId,
    required int amountMinor,
    required CalendarDate paidOn,
    required PaymentMethod method,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('') String receiptNumber,
    @Default('') String note,
  }) = _Payment;
}
