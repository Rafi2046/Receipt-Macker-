import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/item.dart';

part 'item_list_state.freezed.dart';

@freezed
abstract class ItemListState with _$ItemListState {
  const factory ItemListState({
    required List<Item> items,
    @Default('') String query,
  }) = _ItemListState;

  const ItemListState._();

  bool get isSearching => query.trim().isNotEmpty;

  /// Nothing saved yet: show the "add your first item" state.
  bool get isEmpty => items.isEmpty && !isSearching;

  bool get hasNoMatches => items.isEmpty && isSearching;
}
