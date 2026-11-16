import '../../../../core/utils/calendar_date.dart';
import '../models/quote.dart';
import '../models/quote_list_filter.dart';
import '../models/quote_status.dart';
import '../models/quote_summary.dart';

/// Display status: overdue when still pending past [validUntil].
abstract final class QuoteStatusResolver {
  static bool isOverdue(
    QuoteStatus status,
    CalendarDate validUntil, {
    CalendarDate? today,
  }) {
    if (status != QuoteStatus.pending) return false;
    final day = today ?? CalendarDate.fromLocal(DateTime.now());
    return validUntil.key < day.key;
  }

  static bool matchesFilter(
    QuoteSummary summary,
    QuoteListFilter filter, {
    CalendarDate? today,
  }) {
    final overdue = isOverdue(summary.status, summary.validUntil, today: today);
    return switch (filter) {
      QuoteListFilter.all => true,
      QuoteListFilter.pending =>
        summary.status == QuoteStatus.pending && !overdue,
      QuoteListFilter.approved => summary.status == QuoteStatus.approved,
      QuoteListFilter.overdue => overdue,
    };
  }

  static bool quoteMatchesFilter(
    Quote quote,
    QuoteListFilter filter, {
    CalendarDate? today,
  }) {
    final overdue = isOverdue(quote.status, quote.validUntil, today: today);
    return switch (filter) {
      QuoteListFilter.all => true,
      QuoteListFilter.pending =>
        quote.status == QuoteStatus.pending && !overdue,
      QuoteListFilter.approved => quote.status == QuoteStatus.approved,
      QuoteListFilter.overdue => overdue,
    };
  }
}
