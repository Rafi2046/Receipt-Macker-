import '../../../invoices/domain/models/invoice_summary.dart';
import '../models/client_financial_summary.dart';

/// Pure domain calculation of a client's financial summary from invoices.
abstract final class ClientFinanceCalculator {
  static ClientFinancialSummary calculate(
    List<InvoiceSummary> invoices, {
    required String defaultCurrency,
  }) {
    if (invoices.isEmpty) {
      return ClientFinancialSummary(
        totalBilledMinor: 0,
        totalPaidMinor: 0,
        balanceMinor: 0,
        currencyCode: defaultCurrency,
        invoiceCount: 0,
      );
    }

    final currency = invoices.first.currencyCode;
    var totalBilled = 0;
    var totalPaid = 0;

    for (final inv in invoices) {
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
