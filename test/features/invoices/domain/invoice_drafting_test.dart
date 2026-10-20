import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/invoices/domain/logic/invoice_drafting.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount_type.dart';
import 'package:receipt_maker/features/invoices/domain/models/due_term.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';

void main() {
  final t = DateTime.utc(2026, 10, 20);
  final day = CalendarDate(2026, 10, 20);
  final base = Invoice(
    id: 'i',
    number: 'INV-0001',
    currencyCode: 'BDT',
    issueDate: day,
    dueDate: day.addDays(7),
    createdAt: t,
    updatedAt: t,
    stage: InvoiceStage.sent,
    shippingMinor: 5050,
    discount: const Discount(type: DiscountType.flat, value: 1000),
    lines: const [
      LineItem(
        id: 'a',
        name: 'A',
        unitPriceMinor: 50000,
        discount: Discount(type: DiscountType.percent, value: 1000),
      ),
    ],
  );

  test('due term follows the issue date unless custom', () {
    expect(base.dueTerm, DueTerm.days7);
    final moved = base.withIssueDate(day.addDays(3));
    expect(moved.dueDate, day.addDays(10));

    final custom = base.copyWith(dueDate: day.addDays(10));
    expect(custom.dueTerm, DueTerm.custom);
    expect(custom.withIssueDate(day.addDays(3)).dueDate, day.addDays(10));
    expect(base.withDueTerm(DueTerm.days30).dueDate, day.addDays(30));
    expect(base.withDueTerm(DueTerm.custom), base);
  });

  test('currency change keeps the face value of amounts', () {
    final jpy = base.withCurrency('JPY', fromDecimals: 2, toDecimals: 0);
    expect(jpy.currencyCode, 'JPY');
    expect(jpy.lines.single.unitPriceMinor, 500);
    expect(jpy.lines.single.discount?.value, 1000, reason: 'percent kept');
    expect(jpy.discount?.value, 10);
    expect(jpy.shippingMinor, 51, reason: '50.50 rounds half-up');

    final back = jpy.withCurrency('BDT', fromDecimals: 0, toDecimals: 2);
    expect(back.lines.single.unitPriceMinor, 50000);
  });

  test('line edits touch only that line', () {
    final two = base.withLine(const LineItem(id: 'b', name: 'B'));
    final edited = two.editLine('b', (l) => l.copyWith(name: 'Bee'));
    expect(edited.lines.map((l) => l.name), ['A', 'Bee']);
    expect(edited.withoutLine('a').lines.map((l) => l.id), ['b']);
  });

  test('duplicate is a fresh draft with the same term', () {
    var n = 0;
    final copy = base.duplicate(
      id: 'j',
      number: 'INV-0002',
      today: day.addDays(5),
      now: t,
      newLineId: () => 'new${n++}',
    );
    expect(copy.id, 'j');
    expect(copy.stage, InvoiceStage.draft);
    expect(copy.issueDate, day.addDays(5));
    expect(copy.dueDate, day.addDays(12));
    expect(copy.lines.single.id, 'new0');
    expect(copy.lines.single.unitPriceMinor, 50000);
  });

  test('sameContentAs ignores timestamps', () {
    final later = base.copyWith(updatedAt: t.add(const Duration(hours: 1)));
    expect(later.sameContentAs(base), isTrue);
    expect(base.copyWith(notes: 'x').sameContentAs(base), isFalse);
  });
}
