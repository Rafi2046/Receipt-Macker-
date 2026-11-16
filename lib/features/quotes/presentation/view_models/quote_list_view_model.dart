import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/logic/quote_status_resolver.dart';
import '../../domain/models/quote_list_filter.dart';
import '../../providers.dart';
import 'quote_list_state.dart';

part 'quote_list_view_model.g.dart';

@riverpod
class QuoteListViewModel extends _$QuoteListViewModel {
  String _query = '';
  QuoteListFilter _filter = QuoteListFilter.all;

  @override
  Stream<QuoteListState> build() {
    return ref.watch(quoteRepositoryProvider).watchAll(query: _query).map((
      quotes,
    ) {
      final filtered = [
        for (final q in quotes)
          if (QuoteStatusResolver.matchesFilter(q, _filter)) q,
      ];
      return QuoteListState(quotes: filtered, query: _query, filter: _filter);
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
}
