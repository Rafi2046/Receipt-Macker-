import 'package:drift/drift.dart';

/// Saved products and services. Money is integer minor units of
/// [currencyCode]; the default tax is in basis points (1500 = 15%).
@DataClassName('ItemRow')
class ItemsTable extends Table {
  @override
  String get tableName => 'items';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get unit => text().withDefault(const Constant(''))();
  IntColumn get unitPriceMinor => integer()();
  TextColumn get currencyCode => text()();
  IntColumn get defaultTaxBasisPoints => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
