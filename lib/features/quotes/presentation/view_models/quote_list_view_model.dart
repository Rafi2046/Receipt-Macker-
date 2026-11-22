import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/document_filters.dart';
import '../../domain/logic/quote_status_resolver.dart';
import '../../domain/models/quote_list_filter.dart';
import '../../providers.dart';
import 'quote_list_state.dart';

part 'quote_list_view_model.g.dart';

@riverpod
class QuoteListViewModel extends _$QuoteListViewModel {
  String _query = '';
  QuoteListFilter _filter = QuoteListFilter.all;
  DocumentFilters _advanced = const DocumentFilters();

  @override
  Stream<QuoteListState> build() {
    return ref.watch(quoteRepositoryProvider).watchAll(query: _query).map((
      quotes,
    ) {
      final filtered = [
        for (final q in quotes)
          if (QuoteStatusResolver.matchesFilter(q, _filter) &&
              _advanced.matches(
                clientId: q.clientId,
                currencyCode: q.currencyCode,
                issueDate: q.issueDate,
              ))
            q,
      ];
      return QuoteListState(
        quotes: filtered,
        query: _query,
        filter: _filter,
        advanced: _advanced,
      );
    });
  }

  void search(String query) {
    _query = query.trim();
    ref.invalidateSelf();
  }

  void setFilter(QuoteListFilter filter) {
    _filter = filter;
    ref.invalidateSelf();
  }

  void setAdvancedFilters(DocumentFilters advanced) {
    _advanced = advanced;
    ref.invalidateSelf();
  }

  void clearAdvancedFilters() {
    _advanced = const DocumentFilters();
    ref.invalidateSelf();
  }
}
