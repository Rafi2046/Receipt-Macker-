import '../../../core/utils/calendar_date.dart';
import '../../invoices/domain/logic/invoice_status_resolver.dart';
import '../../invoices/domain/models/invoice_status.dart';
import '../../invoices/domain/models/invoice_summary.dart';
import 'home_invoice.dart';

/// What Home shows. Money is minor units of [currencyCode].
class HomeSnapshot {
  const HomeSnapshot({
    required this.businessName,
    required this.currencyCode,
    required this.hour,
    required this.invoicedMinor,
    required this.receivedMinor,
    required this.outstandingMinor,
    required this.overdueCount,
    required this.overdueMinor,
    required this.recent,
  });

  final String businessName;
  final String currencyCode;
  final int hour;
  final int invoicedMinor;
  final int receivedMinor;
  final int outstandingMinor;
  final int overdueCount;
  final int overdueMinor;
  final List<HomeInvoice> recent;

  bool get hasInvoices => recent.isNotEmpty;
}

/// Totals for [today]'s month, plus what is still owed in [currencyCode].
HomeSnapshot assembleHome({
  required List<InvoiceSummary> invoices,
  required CalendarDate today,
  required String currencyCode,
  required String businessName,
  required int hour,
}) {
  var invoiced = 0;
  var received = 0;
  var outstanding = 0;
  var overdueCount = 0;
  var overdueMinor = 0;
  final recent = <HomeInvoice>[];
  for (final invoice in invoices) {
    final status = InvoiceStatusResolver.resolve(
      stage: invoice.stage,
      totalMinor: invoice.totalMinor,
      paidMinor: invoice.paidMinor,
      dueDate: invoice.dueDate,
      today: today,
    );
    if (recent.length < 4) {
      recent.add(HomeInvoice(summary: invoice, status: status));
    }
    if (invoice.currencyCode != currencyCode) continue;
    final balance = invoice.totalMinor - invoice.paidMinor;
    final thisMonth =
        invoice.issueDate.year == today.year &&
        invoice.issueDate.month == today.month;
    if (thisMonth) {
      invoiced += invoice.totalMinor;
      received += invoice.paidMinor;
    }
    if (status == InvoiceStatus.overdue) {
      overdueCount += 1;
      overdueMinor += balance;
    }
    if (status != InvoiceStatus.draft &&
        status != InvoiceStatus.paid &&
        balance > 0) {
      outstanding += balance;
    }
  }
  return HomeSnapshot(
    businessName: businessName,
    currencyCode: currencyCode,
    hour: hour,
    invoicedMinor: invoiced,
    receivedMinor: received,
    outstandingMinor: outstanding,
    overdueCount: overdueCount,
    overdueMinor: overdueMinor,
    recent: recent,
  );
}
