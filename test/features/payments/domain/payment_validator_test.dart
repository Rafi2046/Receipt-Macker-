import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/payments/domain/logic/payment_validator.dart';
import 'package:receipt_maker/features/payments/domain/models/payment.dart';
import 'package:receipt_maker/features/payments/domain/models/payment_field.dart';
import 'package:receipt_maker/features/payments/domain/models/payment_method.dart';

void main() {
  final day = CalendarDate(2026, 10, 20);
  final t = DateTime.utc(2026, 10, 20);

  Payment payment(int amount, {String note = ''}) => Payment(
    id: 'pay',
    invoiceId: 'inv',
    amountMinor: amount,
    paidOn: day,
    method: PaymentMethod.cash,
    note: note,
    createdAt: t,
    updatedAt: t,
  );

  test('amount must be more than zero and within the balance', () {
    expect(PaymentValidator.validate(payment(0), maxMinor: 100), {
      PaymentField.amount: ValidationError.mustBePositive,
    });
    expect(PaymentValidator.validate(payment(101), maxMinor: 100), {
      PaymentField.amount: ValidationError.amountAboveBalance,
    });
    expect(PaymentValidator.validate(payment(100), maxMinor: 100), isEmpty);
  });

  test('a very long note is rejected', () {
    expect(
      PaymentValidator.validate(
        payment(10, note: 'x' * 2001),
        maxMinor: 10,
      )[PaymentField.note],
      ValidationError.tooLong,
    );
  });
}
