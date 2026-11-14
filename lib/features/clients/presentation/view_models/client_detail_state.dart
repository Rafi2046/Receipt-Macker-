import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../invoices/domain/models/invoice_summary.dart';
import '../../domain/models/client.dart';
import '../../domain/models/client_financial_summary.dart';

part 'client_detail_state.freezed.dart';

@freezed
abstract class ClientDetailState with _$ClientDetailState {
  const factory ClientDetailState({
    required Client? client,
    required List<InvoiceSummary> invoices,
    required ClientFinancialSummary finances,
  }) = _ClientDetailState;
}
