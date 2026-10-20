import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/invoices/domain/logic/invoice_calculator.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount_type.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';

void main() {
  final t = DateTime.utc(2026, 10, 20);
  final day = CalendarDate(2026, 10, 20);

  Invoice invoice(
    List<LineItem> lines, {
    String currency = 'BDT',
    Discount? discount,
    int? tax,
    bool inclusive = false,
    int shipping = 0,
  }) => Invoice(
    id: 'i',
    number: 'INV-0001',
    currencyCode: currency,
    issueDate: day,
    dueDate: day,
    createdAt: t,
    updatedAt: t,
    lines: lines,
    discount: discount,
    taxRateBasisPoints: tax,
    taxInclusive: inclusive,
    shippingMinor: shipping,
  );

  LineItem line(int price, int qtyMilli, {Discount? discount}) => LineItem(
    id: '$price-$qtyMilli',
    name: 'x',
    unitPriceMinor: price,
    quantityMilli: qtyMilli,
    discount: discount,
  );

  const pct = DiscountType.percent;
  const flat = DiscountType.flat;

  // ৳123.45 × 1.5 = 185.175 → 185.18; −10% (18.518 → 18.52) = 166.66
  // ৳500 × 2 = 1000; −৳50 flat = 950
  final mixed = [
    line(12345, 1500, discount: const Discount(type: pct, value: 1000)),
    line(50000, 2000, discount: const Discount(type: flat, value: 5000)),
  ];

  group('lines', () {
    test('gross, discount and net round half-up per line', () {
      final totals = InvoiceCalculator.calculate(invoice(mixed));
      expect(totals.lines[0].gross, 18518);
      expect(totals.lines[0].discount, 1852);
      expect(totals.lines[0].net, 16666);
      expect(totals.lines[1].net, 95000);
      expect(totals.subtotal, 111666);
    });

    test('half a poisha rounds up', () {
      expect(InvoiceCalculator.line(line(5, 500), 'BDT').gross, 3);
      expect(InvoiceCalculator.line(line(5, 499), 'BDT').gross, 2);
    });

    test('a flat line discount never exceeds the line', () {
      final l = line(
        1000,
        1000,
        discount: const Discount(type: flat, value: 5000),
      );
      expect(InvoiceCalculator.line(l, 'BDT').net, 0);
    });
  });

  group('invoice discount and tax', () {
    test('exclusive: discount, then tax added, then shipping', () {
      final totals = InvoiceCalculator.calculate(
        invoice(
          mixed,
          discount: const Discount(type: pct, value: 500),
          tax: 1500,
          shipping: 10000,
        ),
      );
      // 5% of 1116.66 = 55.833 → 55.83; taxable 1060.83
      expect(totals.discount, 5583);
      expect(totals.taxableAmount, 106083);
      // 15% of 1060.83 = 159.1245 → 159.12
      expect(totals.tax, 15912);
      expect(totals.total, 106083 + 15912 + 10000);
      expect(totals.balance, totals.total);
    });

    test('inclusive: tax is taken out of the amount, not added', () {
      final totals = InvoiceCalculator.calculate(
        invoice(
          mixed,
          discount: const Discount(type: pct, value: 500),
          tax: 1500,
          inclusive: true,
          shipping: 10000,
        ),
      );
      // 1060.83 / 1.15 = 922.4608… → 922.46 net, so tax 138.37
      expect(totals.tax, 13837);
      expect(totals.total, 106083 + 10000);
    });

    test('inclusive tax on a round amount', () {
      final totals = InvoiceCalculator.calculate(
        invoice([line(11500, 1000)], tax: 1500, inclusive: true),
      );
      expect(totals.tax, 1500);
      expect(totals.total, 11500);
    });

    test('a flat invoice discount is capped at the subtotal', () {
      final totals = InvoiceCalculator.calculate(
        invoice(
          [line(1000, 1000)],
          discount: const Discount(type: flat, value: 99999),
          tax: 1500,
          shipping: 500,
        ),
      );
      expect(totals.discount, 1000);
      expect(totals.tax, 0);
      expect(totals.total, 500);
    });

    test('no tax rate means no tax', () {
      final totals = InvoiceCalculator.calculate(invoice([line(1000, 1000)]));
      expect(totals.tax, 0);
      expect(totals.total, 1000);
    });
  });

  test('zero-decimal currency (JPY)', () {
    final totals = InvoiceCalculator.calculate(
      invoice(
        [line(333, 1000), line(1500, 3000)],
        currency: 'JPY',
        discount: const Discount(type: pct, value: 1000),
        tax: 800,
      ),
    );
    // subtotal ¥4833; 10% = 483.3 → ¥483; taxable ¥4350; 8% = ¥348
    expect(totals.subtotal, 4833);
    expect(totals.discount, 483);
    expect(totals.tax, 348);
    expect(totals.total, 4698);
  });

  test('partial and full payments', () {
    final inv = invoice([line(100000, 1000)], tax: 1000);
    final partial = InvoiceCalculator.calculate(inv, paidMinor: 40000);
    expect(partial.total, 110000);
    expect(partial.balance, 70000);
    final over = InvoiceCalculator.calculate(inv, paidMinor: 120000);
    expect(over.balance, -10000);
  });

  test('an empty invoice is all zeros', () {
    final totals = InvoiceCalculator.calculate(invoice([]));
    expect(totals.subtotal, 0);
    expect(totals.total, 0);
  });

  test('absurd amounts saturate instead of overflowing', () {
    final totals = InvoiceCalculator.calculate(
      invoice([
        line(999999999999999, 999999999),
        line(999999999999999, 999999999),
      ]),
    );
    expect(totals.total, 999999999999999);
  });
}
