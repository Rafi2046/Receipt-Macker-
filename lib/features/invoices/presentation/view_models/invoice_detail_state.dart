import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/invoice.dart';
import '../../domain/models/invoice_status.dart';
import '../../domain/models/invoice_totals.dart';

part 'invoice_detail_state.freezed.dart';

@freezed
abstract class InvoiceDetailState with _$InvoiceDetailState {
  const factory InvoiceDetailState({
    required Invoice invoice,
    required InvoiceTotals totals,
    required InvoiceStatus status,
  }) = _InvoiceDetailState;
}
