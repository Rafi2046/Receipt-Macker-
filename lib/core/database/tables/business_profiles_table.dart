import 'package:drift/drift.dart';

/// One row per business profile. Free plan uses one; the table allows more (v1.1+).
/// Image columns hold paths relative to the app documents directory.
@DataClassName('BusinessProfileRow')
class BusinessProfilesTable extends Table {
  @override
  String get tableName => 'business_profiles';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();
  TextColumn get website => text().withDefault(const Constant(''))();
  TextColumn get taxId => text().withDefault(const Constant(''))();
  TextColumn get paymentInstructions =>
      text().withDefault(const Constant(''))();
  TextColumn get defaultNotes => text().withDefault(const Constant(''))();
  TextColumn get defaultTerms => text().withDefault(const Constant(''))();
  TextColumn get logoPath => text().nullable()();
  TextColumn get signaturePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
