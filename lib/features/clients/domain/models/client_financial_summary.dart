import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_financial_summary.freezed.dart';

/// Aggregated totals for all invoices billed to a client.
@freezed
abstract class ClientFinancialSummary with _$ClientFinancialSummary {
  const factory ClientFinancialSummary({
    required int totalBilledMinor,
    required int totalPaidMinor,
    required int balanceMinor,
    required String currencyCode,
    required int invoiceCount,
  }) = _ClientFinancialSummary;
}
