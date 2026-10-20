import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/services/clock.dart';
import '../../domain/logic/invoice_status_resolver.dart';
import '../../providers.dart';
import 'invoice_list_state.dart';
import 'invoice_search_query.dart';

part 'invoice_list_view_model.g.dart';

/// Invoices, newest first, with their status for today. Filtered by
/// [InvoiceSearchQuery]; updates live as invoices change.
@riverpod
class InvoiceListViewModel extends _$InvoiceListViewModel {
  @override
  Stream<InvoiceListState> build() {
    final query = ref.watch(invoiceSearchQueryProvider);
    final today = ref.watch(clockProvider).today();
    return ref
        .watch(invoiceRepositoryProvider)
        .watchAll(query: query)
        .map(
          (summaries) => InvoiceListState(
            query: query,
            entries: [
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
            ],
          ),
        );
  }

  void search(String query) =>
      ref.read(invoiceSearchQueryProvider.notifier).search(query);
}
