import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/document_filters.dart';
import '../../domain/logic/invoice_overview.dart';
import '../../domain/models/invoice_list_filter.dart';
import '../../domain/models/invoice_period.dart';
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
    /// The rows shown: after search, status chip and filters.
    required List<InvoiceListEntry> entries,
    required InvoiceOverview overview,

    /// Invoices before any chip or filter, to tell "none yet" from "none
    /// match".
    @Default(0) int totalCount,
    @Default('') String query,
    @Default(InvoiceListFilter.all) InvoiceListFilter filter,
    @Default(DocumentFilters()) DocumentFilters advanced,
    @Default(InvoicePeriod.thisMonth) InvoicePeriod period,
  }) = _InvoiceListState;

  const InvoiceListState._();

  bool get isSearching => query.trim().isNotEmpty;

  bool get hasAdvancedFilters => !advanced.isEmpty;

  /// Nothing saved yet: show the "create your first invoice" state.
  bool get isEmpty => totalCount == 0 && !isSearching && !hasAdvancedFilters;
}
