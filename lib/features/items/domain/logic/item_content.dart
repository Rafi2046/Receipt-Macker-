import '../models/item.dart';

extension ItemContent on Item {
  /// Same content, ignoring timestamps. Used to detect unsaved edits.
  bool sameContentAs(Item other) =>
      copyWith(createdAt: other.createdAt, updatedAt: other.updatedAt) == other;
}
