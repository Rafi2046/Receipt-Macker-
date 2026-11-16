import 'package:drift/drift.dart';

import 'business_profiles_table.dart';

@DataClassName('QuoteNumberingRow')
class QuoteNumberingTable extends Table {
  @override
  String get tableName => 'quote_numbering';

  TextColumn get profileId => text().references(BusinessProfilesTable, #id)();
  TextColumn get prefix => text()();
  IntColumn get nextSequence => integer()();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}
