import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/invoice_status.dart';
import '../../domain/models/invoice_summary.dart';

part 'invoice_list_state.freezed.dart';

/// One row of the invoice list: the summary and its worked-out status.
@freezed
abstract class InvoiceListEntry with _$InvoiceListEntry {
  const factory InvoiceListEntry({
    required InvoiceSummary summary,
    required InvoiceStatus status,
  }) = _InvoiceListEntry;
}

@freezed
abstract class InvoiceListState with _$InvoiceListState {
  const factory InvoiceListState({
    required List<InvoiceListEntry> entries,
    @Default('') String query,
  }) = _InvoiceListState;

  const InvoiceListState._();

  bool get isSearching => query.trim().isNotEmpty;

  /// Nothing saved yet: show the "create your first invoice" state.
  bool get isEmpty => entries.isEmpty && !isSearching;
}
