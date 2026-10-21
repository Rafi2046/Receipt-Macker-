import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/dashboard/presentation/home_snapshot.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_status.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_summary.dart';

void main() {
  final today = CalendarDate(2026, 10, 21);

  InvoiceSummary invoice({
    required String id,
    required InvoiceStage stage,
    required int total,
    required int paid,
    required CalendarDate issue,
    required CalendarDate due,
    String currency = 'BDT',
  }) {
    return InvoiceSummary(
      id: id,
      number: id,
      currencyCode: currency,
      issueDate: issue,
      dueDate: due,
      stage: stage,
      totalMinor: total,
      paidMinor: paid,
    );
  }

  test('this month totals and open balances stay in one currency', () {
    final snapshot = assembleHome(
      today: today,
      currencyCode: 'BDT',
      businessName: 'Shop',
      hour: 20,
      invoices: [
        invoice(
          id: 'open',
          stage: InvoiceStage.sent,
          total: 500000,
          paid: 0,
          issue: today,
          due: CalendarDate(2026, 11, 4),
        ),
        invoice(
          id: 'paid',
          stage: InvoiceStage.sent,
          total: 200000,
          paid: 200000,
          issue: today,
          due: today,
        ),
        invoice(
          id: 'late',
          stage: InvoiceStage.sent,
          total: 100000,
          paid: 0,
          issue: CalendarDate(2026, 9, 1),
          due: CalendarDate(2026, 9, 15),
        ),
        invoice(
          id: 'draft',
          stage: InvoiceStage.draft,
          total: 900000,
          paid: 0,
          issue: today,
          due: today,
        ),
        invoice(
          id: 'usd',
          stage: InvoiceStage.sent,
          total: 800000,
          paid: 0,
          issue: today,
          due: CalendarDate(2026, 11, 1),
          currency: 'USD',
        ),
      ],
    );

    expect(snapshot.invoicedMinor, 500000 + 200000 + 900000);
    expect(snapshot.receivedMinor, 200000);
    expect(snapshot.outstandingMinor, 500000 + 100000);
    expect(snapshot.overdueCount, 1);
    expect(snapshot.overdueMinor, 100000);
    expect(snapshot.recent, hasLength(4));
    expect(snapshot.recent.first.status, InvoiceStatus.sent);
    expect(snapshot.hour, 20);
  });
}
