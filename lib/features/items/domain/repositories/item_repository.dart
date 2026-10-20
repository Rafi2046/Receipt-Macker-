import '../../../../core/errors/result.dart';
import '../models/item.dart';

abstract interface class ItemRepository {
  /// All items A-Z; a non-empty [query] filters by name, description or unit.
  Stream<List<Item>> watchAll({String query = ''});

  /// Fails with `NotFoundFailure` when there is no item with [id].
  Future<Result<Item>> find(String id);

  /// Inserts or updates; returns the item as stored.
  Future<Result<Item>> save(Item item);

  Future<Result<void>> delete(String id);
}
