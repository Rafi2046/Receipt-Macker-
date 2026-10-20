import 'package:drift/drift.dart';

import '../app_database.dart';
import '../search_pattern.dart';
import '../tables/clients_table.dart';

part 'client_dao.g.dart';

@DriftAccessor(tables: [ClientsTable])
class ClientDao extends DatabaseAccessor<AppDatabase> with _$ClientDaoMixin {
  ClientDao(super.attachedDatabase);

  /// Clients by name (A-Z, ignoring case). A non-empty [query] matches name,
  /// email or phone; [phoneQuery] is the query with Latin digits.
  Stream<List<ClientRow>> watchAll({String query = '', String? phoneQuery}) {
    final stmt = select(clientsTable)
      ..orderBy([
        (t) => OrderingTerm.asc(t.name.collate(Collate.noCase)),
        (t) => OrderingTerm.asc(t.createdAt),
      ]);
    if (query.isNotEmpty) {
      const esc = SearchPattern.escapeChar;
      final text = SearchPattern.contains(query);
      final digits = SearchPattern.contains(phoneQuery ?? query);
      stmt.where(
        (t) =>
            t.name.like(text, escapeChar: esc) |
            t.email.like(text, escapeChar: esc) |
            t.phone.like(digits, escapeChar: esc),
      );
    }
    return stmt.watch();
  }

  Future<ClientRow?> findById(String id) =>
      (select(clientsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> upsert(ClientRow row) =>
      into(clientsTable).insertOnConflictUpdate(row);

  /// Number of rows removed (0 when the id is unknown).
  Future<int> deleteById(String id) =>
      (delete(clientsTable)..where((t) => t.id.equals(id))).go();
}
