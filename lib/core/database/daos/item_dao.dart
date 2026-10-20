import 'package:drift/drift.dart';

import '../app_database.dart';
import '../search_pattern.dart';
import '../tables/items_table.dart';

part 'item_dao.g.dart';

@DriftAccessor(tables: [ItemsTable])
class ItemDao extends DatabaseAccessor<AppDatabase> with _$ItemDaoMixin {
  ItemDao(super.attachedDatabase);

  /// Items by name (A-Z, ignoring case). A non-empty [query] matches name,
  /// description or unit.
  Stream<List<ItemRow>> watchAll({String query = ''}) {
    final stmt = select(itemsTable)
      ..orderBy([
        (t) => OrderingTerm.asc(t.name.collate(Collate.noCase)),
        (t) => OrderingTerm.asc(t.createdAt),
      ]);
    if (query.isNotEmpty) {
      const esc = SearchPattern.escapeChar;
      final text = SearchPattern.contains(query);
      stmt.where(
        (t) =>
            t.name.like(text, escapeChar: esc) |
            t.description.like(text, escapeChar: esc) |
            t.unit.like(text, escapeChar: esc),
      );
    }
    return stmt.watch();
  }

  Future<ItemRow?> findById(String id) =>
      (select(itemsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(ItemRow row) =>
      into(itemsTable).insertOnConflictUpdate(row);

  /// Number of rows removed (0 when the id is unknown).
  Future<int> deleteById(String id) =>
      (delete(itemsTable)..where((t) => t.id.equals(id))).go();
}
