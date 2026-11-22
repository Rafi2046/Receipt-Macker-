import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/clock.dart';
import '../../../../core/services/service_providers.dart';
import '../../../../core/utils/document_filters.dart';
import '../../domain/logic/invoice_overview.dart';
import '../../domain/logic/invoice_status_resolver.dart';
import '../../domain/models/invoice_list_filter.dart';
import '../../domain/models/invoice_period.dart';
import '../../providers.dart';
import 'invoice_list_state.dart';
import 'invoice_search_query.dart';

part 'invoice_list_view_model.g.dart';

/// Invoices, newest first, with their status for today, an overview of
/// the chosen period, a status chip and extra filters. Updates live.
@riverpod
class InvoiceListViewModel extends _$InvoiceListViewModel {
  InvoiceListFilter _filter = InvoiceListFilter.all;
  DocumentFilters _advanced = const DocumentFilters();
  InvoicePeriod _period = InvoicePeriod.thisMonth;

  @override
  Stream<InvoiceListState> build() {
    final query = ref.watch(invoiceSearchQueryProvider);
    final today = ref.watch(clockProvider).today();
    final currency =
        _advanced.currencyCode ??
        ref.watch(appPreferencesProvider).defaultCurrency ??
        AppConstants.defaultCurrencyCode;
    return ref.watch(invoiceRepositoryProvider).watchAll(query: query).map((
      summaries,
    ) {
      final all = [
        for (final s in summaries)
          InvoiceListEntry(
            summary: s,
            status: InvoiceStatusResolver.resolve(
              stage: s.stage,
              totalMinor: s.totalMinor,
              paidMinor: s.paidMinor,
              dueDate: s.dueDate,
              today: today,
            ),
          ),
      ];
      final matching = [
        for (final e in all)
          if (_advanced.matches(
            clientId: e.summary.clientId,
            currencyCode: e.summary.currencyCode,
            issueDate: e.summary.issueDate,
          ))
            e,
      ];
      return InvoiceListState(
        query: query,
        totalCount: all.length,
        filter: _filter,
        advanced: _advanced,
        period: _period,
        entries: [
          for (final e in matching)
            if (_filter.matches(e.status)) e,
        ],
        overview: InvoiceOverview.of(
          [for (final e in matching) (e.summary, e.status)],
          currencyCode: currency,
          period: _period,
          today: today,
        ),
      );
    });
  }

  void search(String query) =>
      ref.read(invoiceSearchQueryProvider.notifier).search(query);

  void setFilter(InvoiceListFilter filter) {
    _filter = filter;
    ref.invalidateSelf();
  }

  void setAdvancedFilters(DocumentFilters advanced) {
    _advanced = advanced;
    ref.invalidateSelf();
  }

  void setPeriod(InvoicePeriod period) {
    _period = period;
    ref.invalidateSelf();
  }
}
