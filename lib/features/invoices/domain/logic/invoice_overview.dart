import '../../../../core/utils/calendar_date.dart';
import '../models/invoice_period.dart';
import '../models/invoice_status.dart';
import '../models/invoice_summary.dart';

/// Totals above the invoice list, in minor units of [currencyCode].
///
/// Counts invoices in [currencyCode] issued within the period. Paid is
/// money received (part payments too). Unpaid is the balance still owed on
/// sent or partly paid invoices that are not yet due; Overdue is the
/// balance on overdue ones. Drafts count nowhere. Unpaid + Overdue is what
/// is still owed.
class InvoiceOverview {
  const InvoiceOverview({
    required this.currencyCode,
    required this.paidMinor,
    required this.unpaidMinor,
    required this.overdueMinor,
  });

  final String currencyCode;
  final int paidMinor;
  final int unpaidMinor;
  final int overdueMinor;

  static InvoiceOverview of(
    Iterable<(InvoiceSummary, InvoiceStatus)> invoices, {
    required String currencyCode,
    required InvoicePeriod period,
    required CalendarDate today,
  }) {
    var paid = 0;
    var unpaid = 0;
    var overdue = 0;
    for (final (invoice, status) in invoices) {
      if (invoice.currencyCode != currencyCode) continue;
      if (!period.contains(invoice.issueDate, today: today)) continue;
      if (status == InvoiceStatus.draft) continue;
      final balance = invoice.totalMinor - invoice.paidMinor;
      paid += invoice.paidMinor;
      if (balance <= 0) continue;
      if (status == InvoiceStatus.overdue) {
        overdue += balance;
      } else {
        unpaid += balance;
      }
    }
    return InvoiceOverview(
      currencyCode: currencyCode,
      paidMinor: paid,
      unpaidMinor: unpaid,
      overdueMinor: overdue,
    );
  }
}
