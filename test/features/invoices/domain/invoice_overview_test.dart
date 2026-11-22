import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/core/utils/document_filters.dart';
import 'package:receipt_maker/features/invoices/domain/logic/invoice_overview.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_list_filter.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_period.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_status.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_summary.dart';

void main() {
  final today = CalendarDate(2026, 1, 15);

  InvoiceSummary invoice({
    int total = 10000,
    int paid = 0,
    String currency = 'BDT',
    CalendarDate? issued,
    String? clientId,
  }) => InvoiceSummary(
    id: 'i',
    number: 'INV-1',
    currencyCode: currency,
    issueDate: issued ?? today,
    dueDate: today,
    stage: InvoiceStage.sent,
    totalMinor: total,
    paidMinor: paid,
    clientId: clientId,
  );

  group('InvoicePeriod', () {
    test('last month wraps across the new year', () {
      expect(
        InvoicePeriod.lastMonth.contains(
          CalendarDate(2025, 12, 31),
          today: today,
        ),
        isTrue,
      );
      expect(
        InvoicePeriod.lastMonth.contains(
          CalendarDate(2026, 1, 1),
          today: today,
        ),
        isFalse,
      );
    });

    test('this month, this year and all time', () {
      final dec = CalendarDate(2025, 12, 1);
      expect(InvoicePeriod.thisMonth.contains(today, today: today), isTrue);
      expect(InvoicePeriod.thisMonth.contains(dec, today: today), isFalse);
      expect(InvoicePeriod.thisYear.contains(dec, today: today), isFalse);
      expect(InvoicePeriod.allTime.contains(dec, today: today), isTrue);
    });
  });

  test('unpaid chip covers sent, partly paid and overdue, not draft', () {
    const f = InvoiceListFilter.unpaid;
    expect(f.matches(InvoiceStatus.sent), isTrue);
    expect(f.matches(InvoiceStatus.partiallyPaid), isTrue);
    expect(f.matches(InvoiceStatus.overdue), isTrue);
    expect(f.matches(InvoiceStatus.draft), isFalse);
    expect(f.matches(InvoiceStatus.paid), isFalse);
  });

  test('overview splits paid, unpaid and overdue; drafts and other '
      'currencies and periods are left out', () {
    final overview = InvoiceOverview.of(
      [
        (invoice(paid: 10000), InvoiceStatus.paid),
        (invoice(total: 8000, paid: 3000), InvoiceStatus.partiallyPaid),
        (invoice(total: 5000), InvoiceStatus.overdue),
        (invoice(total: 9999), InvoiceStatus.draft),
        (invoice(total: 7000, currency: 'USD'), InvoiceStatus.sent),
        (
          invoice(total: 4000, issued: CalendarDate(2025, 12, 1)),
          InvoiceStatus.sent,
        ),
      ],
      currencyCode: 'BDT',
      period: InvoicePeriod.thisMonth,
      today: today,
    );
    expect(overview.paidMinor, 13000);
    expect(overview.unpaidMinor, 5000);
    expect(overview.overdueMinor, 5000);
  });

  test('document filters match client, currency and date range', () {
    final row = invoice(clientId: 'c1', issued: CalendarDate(2026, 1, 10));
    bool check(DocumentFilters f) => f.matches(
      clientId: row.clientId,
      currencyCode: row.currencyCode,
      issueDate: row.issueDate,
    );
    expect(check(const DocumentFilters()), isTrue);
    expect(check(const DocumentFilters(clientId: 'c2')), isFalse);
    expect(check(const DocumentFilters(currencyCode: 'USD')), isFalse);
    expect(
      check(DocumentFilters(issueFrom: CalendarDate(2026, 1, 11))),
      isFalse,
    );
    expect(check(DocumentFilters(issueTo: CalendarDate(2026, 1, 10))), isTrue);
  });
}
