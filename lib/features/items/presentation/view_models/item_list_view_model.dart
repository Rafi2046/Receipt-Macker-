import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../providers.dart';
import 'item_list_state.dart';
import 'item_search_query.dart';

part 'item_list_view_model.g.dart';

/// Items A-Z, filtered by [ItemSearchQuery]. Updates live as items are
/// added, edited or deleted.
@riverpod
class ItemListViewModel extends _$ItemListViewModel {
  @override
  Stream<ItemListState> build() {
    final query = ref.watch(itemSearchQueryProvider);
    return ref
        .watch(itemRepositoryProvider)
        .watchAll(query: query)
        .map((items) => ItemListState(items: items, query: query));
  }

  void search(String query) =>
      ref.read(itemSearchQueryProvider.notifier).search(query);
}
