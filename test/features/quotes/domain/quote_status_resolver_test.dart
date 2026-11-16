import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/quotes/domain/logic/quote_status_resolver.dart';
import 'package:receipt_maker/features/quotes/domain/models/quote_list_filter.dart';
import 'package:receipt_maker/features/quotes/domain/models/quote_status.dart';
import 'package:receipt_maker/features/quotes/domain/models/quote_summary.dart';

void main() {
  final today = CalendarDate(2026, 11, 16);

  QuoteSummary summary({
    QuoteStatus status = QuoteStatus.pending,
    CalendarDate? validUntil,
  }) => QuoteSummary(
    id: 'q1',
    number: 'QUO-0001',
    currencyCode: 'BDT',
    issueDate: CalendarDate(2026, 11, 1),
    validUntil: validUntil ?? CalendarDate(2026, 11, 10),
    status: status,
    totalMinor: 1000,
  );

  test('pending past validUntil is overdue', () {
    expect(
      QuoteStatusResolver.isOverdue(
        QuoteStatus.pending,
        CalendarDate(2026, 11, 10),
        today: today,
      ),
      isTrue,
    );
    expect(
      QuoteStatusResolver.isOverdue(
        QuoteStatus.approved,
        CalendarDate(2026, 11, 10),
        today: today,
      ),
      isFalse,
    );
  });

  test('filter chips match expected rows', () {
    final overdue = summary();
    final pending = summary(validUntil: CalendarDate(2026, 11, 30));
    final approved = summary(status: QuoteStatus.approved);

    expect(
      QuoteStatusResolver.matchesFilter(
        overdue,
        QuoteListFilter.overdue,
        today: today,
      ),
      isTrue,
    );
    expect(
      QuoteStatusResolver.matchesFilter(
        pending,
        QuoteListFilter.pending,
        today: today,
      ),
      isTrue,
    );
    expect(
      QuoteStatusResolver.matchesFilter(
        overdue,
        QuoteListFilter.pending,
        today: today,
      ),
      isFalse,
    );
    expect(
      QuoteStatusResolver.matchesFilter(
        approved,
        QuoteListFilter.approved,
        today: today,
      ),
      isTrue,
    );
  });
}
