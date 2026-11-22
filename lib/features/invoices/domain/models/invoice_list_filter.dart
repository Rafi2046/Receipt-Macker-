import 'invoice_status.dart';

/// The status chips above the invoice list.
enum InvoiceListFilter {
  all,
  draft,
  unpaid,
  partiallyPaid,
  overdue,
  paid;

  /// Unpaid means sent and still owed: sent, partly paid or overdue.
  bool matches(InvoiceStatus status) => switch (this) {
    InvoiceListFilter.all => true,
    InvoiceListFilter.draft => status == InvoiceStatus.draft,
    InvoiceListFilter.unpaid =>
      status == InvoiceStatus.sent ||
          status == InvoiceStatus.partiallyPaid ||
          status == InvoiceStatus.overdue,
    InvoiceListFilter.partiallyPaid => status == InvoiceStatus.partiallyPaid,
    InvoiceListFilter.overdue => status == InvoiceStatus.overdue,
    InvoiceListFilter.paid => status == InvoiceStatus.paid,
  };
}
