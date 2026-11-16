import 'package:drift/drift.dart';

import 'items_table.dart';
import 'quotes_table.dart';

@DataClassName('QuoteLineRow')
class QuoteLinesTable extends Table {
  @override
  String get tableName => 'quote_lines';

  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(QuotesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get itemId => text().nullable().references(
    ItemsTable,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get quantityMilli => integer()();
  TextColumn get unit => text().withDefault(const Constant(''))();
  IntColumn get unitPriceMinor => integer()();
  TextColumn get discountType => text().nullable()();
  IntColumn get discountValue => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
