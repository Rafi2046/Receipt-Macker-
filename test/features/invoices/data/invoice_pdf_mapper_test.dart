import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/core/utils/formatters.dart';
import 'package:receipt_maker/features/business_profile/business_profile.dart';
import 'package:receipt_maker/features/invoices/data/mappers/invoice_pdf_mapper.dart';
import 'package:receipt_maker/features/invoices/domain/logic/invoice_calculator.dart';
import 'package:receipt_maker/features/invoices/domain/models/bill_to.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount_type.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';
import 'package:receipt_maker/l10n/gen/app_localizations.dart';

void main() {
  setUpAll(initializeDateFormatting);

  final t = DateTime.utc(2026, 10, 20);
  final seller = BusinessProfile(
    id: 'p',
    name: 'Rahman Traders',
    phone: '01712345678',
    taxId: '001234567',
    createdAt: t,
    updatedAt: t,
  );
  final invoice = Invoice(
    id: 'i',
    number: 'INV-0012',
    currencyCode: 'BDT',
    issueDate: CalendarDate(2026, 10, 20),
    dueDate: CalendarDate(2026, 10, 27),
    createdAt: t,
    updatedAt: t,
    billTo: const BillTo(name: 'Karim', phone: '01811223344'),
    lines: const [
      LineItem(
        id: 'a',
        name: 'Consulting',
        unit: 'hour',
        quantityMilli: 2500,
        unitPriceMinor: 120000,
        discount: Discount(type: DiscountType.percent, value: 1000),
      ),
    ],
    discount: const Discount(type: DiscountType.flat, value: 10000),
    taxRateBasisPoints: 1500,
    shippingMinor: 5000,
    notes: 'Thanks',
  );

  InvoicePdfMapper mapper(String lang) => InvoicePdfMapper(
    lookupAppLocalizations(Locale(lang)),
    AppFormatters(lang),
  );

  test('English: labels, amounts, discount note and totals', () {
    final doc = mapper('en').map(
      invoice: invoice,
      totals: InvoiceCalculator.calculate(invoice),
      seller: seller,
    );
    expect(doc.title, 'Invoice');
    expect(doc.number, 'INV-0012');
    expect(doc.columns, ['Item', 'Qty', 'Price', 'Amount']);
    expect(doc.lines.single.quantity, '2.5 hour');
    expect(doc.lines.single.amount, '৳2,700.00');
    expect(doc.lines.single.discountNote, 'Less 10%');
    expect(doc.totals.map((f) => f.label), [
      'Subtotal',
      'Discount',
      'Tax 15%',
      'Shipping',
    ]);
    expect(doc.totals[1].value, '-৳100.00');
    expect(doc.grandTotal.value, '৳3,040.00');
    expect(doc.meta.last.value, 'Oct 27, 2026');
    expect(doc.seller.lines, contains('VAT/BIN: 001234567'));
    expect(doc.buyer?.name, 'Karim');
    expect(doc.notes.single.value, 'Thanks');
    expect(doc.pageLabelParts, ['Page ', ' of ', '']);
  });

  test('Bangla: labels and every digit in Bangla', () {
    final doc = mapper('bn').map(
      invoice: invoice,
      totals: InvoiceCalculator.calculate(invoice),
      seller: seller,
    );
    expect(doc.languageCode, 'bn');
    expect(doc.title, 'ইনভয়েস');
    expect(doc.number, 'INV-০০১২');
    expect(doc.lines.single.quantity, '২.৫ hour');
    expect(doc.grandTotal.value, '৳৩,০৪০.০০');
    expect(doc.buyer?.lines, contains('০১৮১১২২৩৩৪৪'));
    expect(doc.pageLabelParts, ['পৃষ্ঠা ', ' / ', '']);
  });

  test('no client, no notes, no zero rows', () {
    final plain = invoice.copyWith(
      billTo: null,
      discount: null,
      shippingMinor: 0,
      taxRateBasisPoints: null,
      notes: '',
    );
    final doc = mapper('en').map(
      invoice: plain,
      totals: InvoiceCalculator.calculate(plain),
      seller: seller,
    );
    expect(doc.buyer, isNull);
    expect(doc.notes, isEmpty);
    expect(doc.totals.map((f) => f.label), ['Subtotal']);
  });
}
