import '../../../invoices/domain/models/invoice_stage.dart';
import '../../../invoices/domain/models/invoice_summary.dart';
import '../models/client_financial_summary.dart';

/// A client's totals from their invoices.
///
/// Money in different currencies is never added together: the totals cover
/// one currency, the default one when the client has invoices in it, else
/// the currency of their newest invoice. Drafts are not billed yet, so
/// they are left out of the money (but still counted as invoices).
abstract final class ClientFinanceCalculator {
  static ClientFinancialSummary calculate(
    List<InvoiceSummary> invoices, {
    required String defaultCurrency,
  }) {
    final sent = [
      for (final inv in invoices)
        if (inv.stage != InvoiceStage.draft) inv,
    ];
    final currency =
        sent.any((inv) => inv.currencyCode == defaultCurrency) || sent.isEmpty
        ? defaultCurrency
        : sent.first.currencyCode;
    var totalBilled = 0;
    var totalPaid = 0;
    for (final inv in sent) {
      if (inv.currencyCode != currency) continue;
      totalBilled += inv.totalMinor;
      totalPaid += inv.paidMinor;
    }
    return ClientFinancialSummary(
      totalBilledMinor: totalBilled,
      totalPaidMinor: totalPaid,
      balanceMinor: totalBilled - totalPaid,
      currencyCode: currency,
      invoiceCount: invoices.length,
    );
  }
}
