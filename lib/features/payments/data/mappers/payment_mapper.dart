import '../../../../core/database/app_database.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/payment_method.dart';

extension PaymentRowMapper on PaymentRow {
  Payment toDomain() => Payment(
    id: id,
    invoiceId: invoiceId,
    amountMinor: amountMinor,
    paidOn: CalendarDate.fromKey(paidOn),
    method: _method(method),
    receiptNumber: receiptNumber,
    note: note,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}

extension PaymentToRow on Payment {
  PaymentRow toRow({
    required String profileId,
    required String receiptNumber,
  }) => PaymentRow(
    id: id,
    profileId: profileId,
    invoiceId: invoiceId,
    amountMinor: amountMinor,
    paidOn: paidOn.key,
    method: method.name,
    note: note.trim(),
    receiptNumber: receiptNumber,
    createdAt: createdAt.toUtc(),
    updatedAt: updatedAt.toUtc(),
  );
}

PaymentMethod _method(String name) =>
    PaymentMethod.values.asNameMap()[name] ?? PaymentMethod.other;
