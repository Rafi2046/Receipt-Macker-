import 'package:drift/drift.dart';

import '../app_database.dart';
import '../search_pattern.dart';
import '../tables/invoice_lines_table.dart';
import '../tables/invoice_numbering_table.dart';
import '../tables/invoices_table.dart';

part 'invoice_dao.g.dart';

@DriftAccessor(
  tables: [InvoicesTable, InvoiceLinesTable, InvoiceNumberingTable],
)
class InvoiceDao extends DatabaseAccessor<AppDatabase> with _$InvoiceDaoMixin {
  InvoiceDao(super.attachedDatabase);

  /// Newest issue date first, then newest number. A non-empty [query]
  /// matches the number or the bill-to name.
  Stream<List<InvoiceRow>> watchAll({String query = ''}) {
    final stmt = select(invoicesTable)
      ..orderBy([
        (t) => OrderingTerm.desc(t.issueDate),
        (t) => OrderingTerm.desc(t.createdAt),
        (t) => OrderingTerm.desc(t.number),
      ]);
    if (query.isNotEmpty) {
      const esc = SearchPattern.escapeChar;
      final text = SearchPattern.contains(query);
      stmt.where(
        (t) =>
            t.number.like(text, escapeChar: esc) |
            t.billToName.like(text, escapeChar: esc),
      );
    }
    return stmt.watch();
  }

  SimpleSelectStatement<$InvoicesTableTable, InvoiceRow> _byId(String id) =>
      select(invoicesTable)..where((t) => t.id.equals(id));

  Stream<InvoiceRow?> watchById(String id) => _byId(id).watchSingleOrNull();

  Future<InvoiceRow?> findById(String id) => _byId(id).getSingleOrNull();

  SimpleSelectStatement<$InvoiceLinesTableTable, InvoiceLineRow> _lines(
    String invoiceId,
  ) => select(invoiceLinesTable)
    ..where((t) => t.invoiceId.equals(invoiceId))
    ..orderBy([(t) => OrderingTerm.asc(t.position)]);

  Future<List<InvoiceLineRow>> linesOf(String invoiceId) =>
      _lines(invoiceId).get();

  Stream<List<InvoiceLineRow>> watchLinesOf(String invoiceId) =>
      _lines(invoiceId).watch();

  /// True when another invoice of [profileId] already uses [number].
  Future<bool> numberTaken(
    String profileId,
    String number, {
    required String exceptId,
  }) async {
    final query = selectOnly(invoicesTable)
      ..addColumns([invoicesTable.id])
      ..where(
        invoicesTable.profileId.equals(profileId) &
            invoicesTable.number.equals(number) &
            invoicesTable.id.equals(exceptId).not(),
      )
      ..limit(1);
    return (await query.get()).isNotEmpty;
  }

  /// Writes the invoice and replaces all its lines.
  Future<void> upsertWithLines(
    InvoiceRow invoice,
    List<InvoiceLineRow> lines,
  ) async {
    await into(invoicesTable).insertOnConflictUpdate(invoice);
    await (delete(
      invoiceLinesTable,
    )..where((t) => t.invoiceId.equals(invoice.id))).go();
    await batch((b) => b.insertAll(invoiceLinesTable, lines));
  }

  /// Lines go with it (cascade). Number of invoices removed.
  Future<int> deleteById(String id) =>
      (delete(invoicesTable)..where((t) => t.id.equals(id))).go();

  Future<InvoiceNumberingRow?> numberingOf(String profileId) => (select(
    invoiceNumberingTable,
  )..where((t) => t.profileId.equals(profileId))).getSingleOrNull();

  Future<void> upsertNumbering(InvoiceNumberingRow row) =>
      into(invoiceNumberingTable).insertOnConflictUpdate(row);
}
