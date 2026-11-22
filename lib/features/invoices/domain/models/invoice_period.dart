import '../../../../core/utils/calendar_date.dart';

/// The time span the invoice overview totals cover, by issue date.
enum InvoicePeriod {
  thisMonth,
  lastMonth,
  thisYear,
  allTime;

  bool contains(CalendarDate issueDate, {required CalendarDate today}) {
    switch (this) {
      case InvoicePeriod.thisMonth:
        return issueDate.year == today.year && issueDate.month == today.month;
      case InvoicePeriod.lastMonth:
        final lastYear = today.month == 1 ? today.year - 1 : today.year;
        final lastMonth = today.month == 1 ? 12 : today.month - 1;
        return issueDate.year == lastYear && issueDate.month == lastMonth;
      case InvoicePeriod.thisYear:
        return issueDate.year == today.year;
      case InvoicePeriod.allTime:
        return true;
    }
  }
}
