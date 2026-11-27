import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/invoices/domain/logic/invoice_validator.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_field.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';

void main() {
  final t = DateTime.utc(2026, 11);
  final day = CalendarDate(2026, 11, 1);

  Invoice invoice({required int price, required int paid}) => Invoice(
    id: 'i',
    number: 'INV-0001',
    currencyCode: 'BDT',
    issueDate: day,
    dueDate: day,
    lines: [LineItem(id: 'l', name: 'Work', unitPriceMinor: price)],
    paidMinor: paid,
    createdAt: t,
    updatedAt: t,
  );

  test('an invoice cannot be edited below what was already paid', () {
    final low = InvoiceValidator.validate(invoice(price: 30000, paid: 50000));
    expect(low.fields[InvoiceField.total], ValidationError.belowPaid);

    final equal = InvoiceValidator.validate(invoice(price: 50000, paid: 50000));
    expect(equal.isValid, isTrue, reason: 'exactly paid is fine');
  });
}
