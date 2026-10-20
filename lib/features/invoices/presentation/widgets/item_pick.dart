import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../items/items.dart';

part 'item_pick.freezed.dart';

/// What the user chose in the item picker.
@freezed
sealed class ItemPick with _$ItemPick {
  /// A saved (or just created) item.
  const factory ItemPick.saved(Item item) = SavedItemPick;

  /// A line typed in for this invoice only.
  const factory ItemPick.oneOff() = OneOffItemPick;
}
