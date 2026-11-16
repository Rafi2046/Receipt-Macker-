import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/quotes/domain/logic/quote_advanced_filters.dart';
import 'package:receipt_maker/features/quotes/domain/logic/quote_status_resolver.dart';
import 'package:receipt_maker/features/quotes/domain/models/quote_list_filter.dart';
import 'package:receipt_maker/features/quotes/domain/models/quote_status.dart';
import 'package:receipt_maker/features/quotes/domain/models/quote_summary.dart';

void main() {
  final today = CalendarDate(2026, 11, 16);

  QuoteSummary summary({
    QuoteStatus status = QuoteStatus.pending,
    CalendarDate? validUntil,
    CalendarDate? issueDate,
    String? clientId,
    String currencyCode = 'BDT',
  }) => QuoteSummary(
    id: 'q1',
    number: 'QUO-0001',
    currencyCode: currencyCode,
    issueDate: issueDate ?? CalendarDate(2026, 11, 1),
    validUntil: validUntil ?? CalendarDate(2026, 11, 10),
    status: status,
    totalMinor: 1000,
    clientId: clientId,
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
    final cancelled = summary(status: QuoteStatus.rejected);

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
    expect(
      QuoteStatusResolver.matchesFilter(
        cancelled,
        QuoteListFilter.cancelled,
        today: today,
      ),
      isTrue,
    );
    expect(
      QuoteStatusResolver.matchesFilter(
        pending,
        QuoteListFilter.cancelled,
        today: today,
      ),
      isFalse,
    );
  });

  test('advanced filters match client currency and issue dates', () {
    final row = summary(
      clientId: 'c1',
      currencyCode: 'USD',
      issueDate: CalendarDate(2026, 11, 5),
    );
    expect(
      const QuoteAdvancedFilters(clientId: 'c1').matches(row),
      isTrue,
    );
    expect(
      const QuoteAdvancedFilters(clientId: 'c2').matches(row),
      isFalse,
    );
    expect(
      const QuoteAdvancedFilters(currencyCode: 'USD').matches(row),
      isTrue,
    );
    expect(
      const QuoteAdvancedFilters(currencyCode: 'BDT').matches(row),
      isFalse,
    );
    expect(
      QuoteAdvancedFilters(
        issueFrom: CalendarDate(2026, 11, 1),
        issueTo: CalendarDate(2026, 11, 10),
      ).matches(row),
      isTrue,
    );
    expect(
      QuoteAdvancedFilters(
        issueFrom: CalendarDate(2026, 11, 6),
      ).matches(row),
      isFalse,
    );
  });
}
