import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item_search_query.g.dart';

/// What the user typed in the item search box. Resets when the list closes.
@riverpod
class ItemSearchQuery extends _$ItemSearchQuery {
  @override
  String build() => '';

  void search(String query) => state = query;
}
