import 'package:drift/drift.dart';

import '../../../features/invoices/domain/logic/invoice_number_generator.dart';
import '../app_database.dart';
import '../search_pattern.dart';
import '../tables/quote_lines_table.dart';
import '../tables/quote_numbering_table.dart';
import '../tables/quotes_table.dart';

part 'quote_dao.g.dart';

@DriftAccessor(tables: [QuotesTable, QuoteLinesTable, QuoteNumberingTable])
class QuoteDao extends DatabaseAccessor<AppDatabase> with _$QuoteDaoMixin {
  QuoteDao(super.attachedDatabase);

  Stream<List<QuoteRow>> watchAll({String query = ''}) {
    final stmt = select(quotesTable)
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

  SimpleSelectStatement<$QuotesTableTable, QuoteRow> _byId(String id) =>
      select(quotesTable)..where((t) => t.id.equals(id));

  Future<QuoteRow?> findById(String id) => _byId(id).getSingleOrNull();

  Stream<QuoteRow?> watchById(String id) => _byId(id).watchSingleOrNull();

  Future<List<QuoteLineRow>> linesOf(String quoteId) =>
      (select(quoteLinesTable)
            ..where((t) => t.quoteId.equals(quoteId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();

  Future<bool> numberTaken(
    String profileId,
    String number, {
    required String exceptId,
  }) async {
    final query = selectOnly(quotesTable)
      ..addColumns([quotesTable.id])
      ..where(
        quotesTable.profileId.equals(profileId) &
            quotesTable.number.equals(number) &
            quotesTable.id.equals(exceptId).not(),
      )
      ..limit(1);
    return (await query.get()).isNotEmpty;
  }

  Future<void> upsert(QuoteRow quote, List<QuoteLineRow> lines) =>
      transaction(() async {
        await into(quotesTable).insertOnConflictUpdate(quote);
        await (delete(
          quoteLinesTable,
        )..where((t) => t.quoteId.equals(quote.id))).go();
        for (final line in lines) {
          await into(quoteLinesTable).insert(line);
        }
      });

  Future<void> deleteById(String id) =>
      (delete(quotesTable)..where((t) => t.id.equals(id))).go();

  Future<QuoteNumberingRow> numberingFor(
    String profileId, {
    String defaultPrefix = 'QUO-',
  }) async {
    final existing = await (select(
      quoteNumberingTable,
    )..where((t) => t.profileId.equals(profileId))).getSingleOrNull();
    if (existing != null) return existing;
    final row = QuoteNumberingRow(
      profileId: profileId,
      prefix: defaultPrefix,
      nextSequence: 1,
    );
    await into(quoteNumberingTable).insert(row);
    return row;
  }

  Future<void> bumpNumbering({
    required String profileId,
    required String prefix,
    required String savedNumber,
  }) async {
    final current = await numberingFor(profileId, defaultPrefix: prefix);
    final next = InvoiceNumberGenerator.nextAfterSaving(
      current.nextSequence,
      current.prefix,
      savedNumber,
    );
    await into(quoteNumberingTable).insertOnConflictUpdate(
      QuoteNumberingRow(
        profileId: profileId,
        prefix: current.prefix,
        nextSequence: next,
      ),
    );
  }
}
