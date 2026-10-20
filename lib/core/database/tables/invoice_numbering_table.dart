import 'package:drift/drift.dart';

import 'business_profiles_table.dart';

/// Invoice number prefix and the next sequence, per business profile.
/// Created on first use; the settings screen (M7) edits it.
@DataClassName('InvoiceNumberingRow')
class InvoiceNumberingTable extends Table {
  @override
  String get tableName => 'invoice_numbering';

  TextColumn get profileId => text().references(BusinessProfilesTable, #id)();
  TextColumn get prefix => text()();
  IntColumn get nextSequence => integer()();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}
