import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/invoices/domain/logic/invoice_number_generator.dart';
import 'package:receipt_maker/features/invoices/domain/logic/invoice_status_resolver.dart';
import 'package:receipt_maker/features/invoices/domain/logic/invoice_validator.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount_type.dart';
import 'package:receipt_maker/features/invoices/domain/models/due_term.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_field.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_status.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_field.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';

void main() {
  group('status', () {
    final due = CalendarDate(2026, 10, 20);
    InvoiceStatus status({
      InvoiceStage stage = InvoiceStage.sent,
      int total = 1000,
      int paid = 0,
      CalendarDate? today,
    }) => InvoiceStatusResolver.resolve(
      stage: stage,
      totalMinor: total,
      paidMinor: paid,
      dueDate: due,
      today: today ?? due,
    );

    test('draft until sent, even when overdue', () {
      expect(status(stage: InvoiceStage.draft), InvoiceStatus.draft);
      expect(
        status(stage: InvoiceStage.draft, today: due.addDays(9)),
        InvoiceStatus.draft,
      );
    });

    test('the due day itself is not overdue; the day after is', () {
      expect(status(), InvoiceStatus.sent);
      expect(status(today: due.addDays(1)), InvoiceStatus.overdue);
    });

    test('partial, paid, and overdue with a balance', () {
      expect(status(paid: 400), InvoiceStatus.partiallyPaid);
      expect(status(paid: 1000), InvoiceStatus.paid);
      expect(status(paid: 1000, today: due.addDays(5)), InvoiceStatus.paid);
      expect(status(paid: 400, today: due.addDays(5)), InvoiceStatus.overdue);
    });

    test('a payment on a draft counts', () {
      expect(
        status(stage: InvoiceStage.draft, paid: 400),
        InvoiceStatus.partiallyPaid,
      );
    });
  });

  group('numbering', () {
    test('formats with padding', () {
      expect(InvoiceNumberGenerator.format('INV-', 7, padding: 4), 'INV-0007');
      expect(
        InvoiceNumberGenerator.format('INV-', 12345, padding: 4),
        'INV-12345',
      );
    });

    test('reads the sequence only from prefix + digits', () {
      expect(InvoiceNumberGenerator.sequenceOf('INV-', 'INV-0012'), 12);
      expect(InvoiceNumberGenerator.sequenceOf('INV-', 'INV-12A'), isNull);
      expect(InvoiceNumberGenerator.sequenceOf('INV-', 'Q-0012'), isNull);
      expect(InvoiceNumberGenerator.sequenceOf('INV-', 'INV-'), isNull);
    });

    test('only moves forward', () {
      expect(InvoiceNumberGenerator.nextAfterSaving(7, 'INV-', 'INV-0007'), 8);
      expect(
        InvoiceNumberGenerator.nextAfterSaving(7, 'INV-', 'INV-0100'),
        101,
      );
      expect(InvoiceNumberGenerator.nextAfterSaving(7, 'INV-', 'INV-0003'), 7);
      expect(InvoiceNumberGenerator.nextAfterSaving(7, 'INV-', 'Custom'), 7);
    });
  });

  test('due terms map from days', () {
    expect(DueTerm.fromDays(0), DueTerm.onReceipt);
    expect(DueTerm.fromDays(15), DueTerm.days15);
    expect(DueTerm.fromDays(10), DueTerm.custom);
  });

  group('validator', () {
    final day = CalendarDate(2026, 10, 20);
    final t = DateTime.utc(2026, 10, 20);
    const ok = LineItem(id: 'l1', name: 'Design', unitPriceMinor: 1000);
    Invoice inv({
      String number = 'INV-0001',
      List<LineItem> lines = const [ok],
      CalendarDate? due,
      Discount? discount,
      int? tax,
    }) => Invoice(
      id: 'i',
      number: number,
      currencyCode: 'BDT',
      issueDate: day,
      dueDate: due ?? day,
      createdAt: t,
      updatedAt: t,
      lines: lines,
      discount: discount,
      taxRateBasisPoints: tax,
    );

    test('a complete invoice is valid', () {
      expect(InvoiceValidator.validate(inv()).isValid, isTrue);
    });

    test('invoice-level errors', () {
      final v = InvoiceValidator.validate(
        inv(
          number: ' ',
          lines: [],
          due: day.addDays(-1),
          discount: const Discount(type: DiscountType.flat, value: 1),
          tax: 10001,
        ),
      );
      expect(v.fields, {
        InvoiceField.number: ValidationError.required,
        InvoiceField.dueDate: ValidationError.dueBeforeIssue,
        InvoiceField.lines: ValidationError.noLines,
        InvoiceField.discount: ValidationError.discountTooLarge,
        InvoiceField.tax: ValidationError.percentTooHigh,
      });
    });

    test('line errors are keyed by line id', () {
      const bad = LineItem(
        id: 'l2',
        name: '',
        quantityMilli: 0,
        discount: Discount(type: DiscountType.percent, value: 20000),
      );
      final v = InvoiceValidator.validate(inv(lines: [ok, bad]));
      expect(v.lines.keys, ['l2']);
      expect(v.forLine('l2'), {
        LineField.name: ValidationError.required,
        LineField.quantity: ValidationError.mustBePositive,
        LineField.discount: ValidationError.percentTooHigh,
      });
    });

    test('a zero price is allowed but a huge line is not', () {
      const free = LineItem(id: 'f', name: 'Free');
      const huge = LineItem(
        id: 'h',
        name: 'Huge',
        unitPriceMinor: 999999999999999,
        quantityMilli: 2000,
      );
      final v = InvoiceValidator.validate(inv(lines: [free, huge]));
      expect(v.forLine('f'), isEmpty);
      expect(v.forLine('h'), {LineField.total: ValidationError.amountTooLarge});
      expect(v.fields[InvoiceField.total], ValidationError.amountTooLarge);
    });
  });
}
