import 'package:drift/drift.dart';

import 'invoices_table.dart';
import 'items_table.dart';

/// Lines of an invoice, in [position] order. Deleted with their invoice.
@DataClassName('InvoiceLineRow')
class InvoiceLinesTable extends Table {
  @override
  String get tableName => 'invoice_lines';

  TextColumn get id => text()();
  TextColumn get invoiceId =>
      text().references(InvoicesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get position => integer()();
  TextColumn get itemId => text().nullable().references(
    ItemsTable,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();

  /// Thousandths (1500 = 1.5).
  IntColumn get quantityMilli => integer()();
  TextColumn get unit => text().withDefault(const Constant(''))();
  IntColumn get unitPriceMinor => integer()();
  TextColumn get discountType => text().nullable()();
  IntColumn get discountValue => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
