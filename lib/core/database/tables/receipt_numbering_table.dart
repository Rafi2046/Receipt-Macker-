import 'package:drift/drift.dart';

import 'business_profiles_table.dart';

/// Receipt number prefix and the next sequence, per business profile.
/// Created on the first payment. Settings (M7) can edit it later.
@DataClassName('ReceiptNumberingRow')
class ReceiptNumberingTable extends Table {
  @override
  String get tableName => 'receipt_numbering';

  TextColumn get profileId => text().references(BusinessProfilesTable, #id)();
  TextColumn get prefix => text()();
  IntColumn get nextSequence => integer()();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}
