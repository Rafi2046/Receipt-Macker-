import '../../invoices/domain/models/invoice_status.dart';
import '../../invoices/domain/models/invoice_summary.dart';

/// One recent invoice, with the status Home should label.
class HomeInvoice {
  const HomeInvoice({required this.summary, required this.status});

  final InvoiceSummary summary;
  final InvoiceStatus status;
}
