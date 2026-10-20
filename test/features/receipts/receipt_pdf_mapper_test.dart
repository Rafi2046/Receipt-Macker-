import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/core/utils/formatters.dart';
import 'package:receipt_maker/features/business_profile/domain/models/business_profile.dart';
import 'package:receipt_maker/features/invoices/domain/models/bill_to.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/payments/domain/models/payment.dart';
import 'package:receipt_maker/features/payments/domain/models/payment_method.dart';
import 'package:receipt_maker/features/receipts/data/mappers/receipt_pdf_mapper.dart';
import 'package:receipt_maker/features/receipts/domain/logic/receipt_balance.dart';
import 'package:receipt_maker/l10n/gen/app_localizations.dart';

void main() {
  setUpAll(initializeDateFormatting);

  final t = DateTime.utc(2026, 10, 20);
  final day = CalendarDate(2026, 10, 20);
  final seller = BusinessProfile(
    id: 'p',
    name: 'Rahman Traders',
    phone: '01712345678',
    createdAt: t,
    updatedAt: t,
  );
  final invoice = Invoice(
    id: 'inv',
    number: 'INV-0004',
    currencyCode: 'BDT',
    issueDate: day,
    dueDate: day.addDays(7),
    createdAt: t,
    updatedAt: t,
    billTo: const BillTo(name: 'করিম স্টোর', phone: '01811223344'),
  );
  final payment = Payment(
    id: 'a',
    invoiceId: 'inv',
    amountMinor: 20000,
    paidOn: day,
    method: PaymentMethod.bkash,
    receiptNumber: 'RCPT-0001',
    createdAt: t,
    updatedAt: t,
  );

  ReceiptPdfMapper mapper(String lang) => ReceiptPdfMapper(
    lookupAppLocalizations(Locale(lang)),
    AppFormatters(lang),
  );

  test('English receipt names the payment, method and balance', () {
    final doc = mapper('en').map(
      payment: payment,
      invoice: invoice,
      balanceAfter: 30000,
      seller: seller,
    );
    expect(doc.title, 'Receipt');
    expect(doc.number, 'RCPT-0001');
    expect(doc.buyerHeading, 'Received from');
    expect(doc.buyer?.name, 'করিম স্টোর');
    expect(doc.lines.single.name, 'Payment for INV-0004');
    expect(doc.lines.single.amount, '৳200.00');
    expect(doc.grandTotal.label, 'Amount received');
    expect(doc.meta.map((f) => f.value), ['Oct 20, 2026', 'bKash', 'INV-0004']);
    expect(doc.afterTotal.single.value, '৳300.00');
    expect(doc.stamp, isNull);
  });

  test('Bangla receipt uses Bangla labels and digits', () {
    final doc = mapper(
      'bn',
    ).map(payment: payment, invoice: invoice, balanceAfter: 0, seller: seller);
    expect(doc.title, 'রসিদ');
    expect(doc.number, 'RCPT-০০০১');
    expect(doc.lines.single.amount, '৳২০০.০০');
    expect(doc.meta[1].value, 'বিকাশ');
    expect(doc.grandTotal.value, '৳২০০.০০');
    expect(doc.stamp, 'পরিশোধিত');
    expect(doc.buyer?.lines.join(), contains('০১৮১১২২৩৩৪৪'));
  });

  test('balance counts this payment and earlier ones only', () {
    Payment pay(String id, int amount, int hour) => Payment(
      id: id,
      invoiceId: 'inv',
      amountMinor: amount,
      paidOn: day,
      method: PaymentMethod.cash,
      createdAt: t.add(Duration(hours: hour)),
      updatedAt: t,
    );
    final payments = [pay('b', 10000, 2), pay('a', 20000, 1)];
    expect(
      balanceAfterPayment(
        totalMinor: 50000,
        payments: payments,
        paymentId: 'a',
      ),
      30000,
    );
    expect(
      balanceAfterPayment(
        totalMinor: 50000,
        payments: payments,
        paymentId: 'b',
      ),
      20000,
    );
  });
}
