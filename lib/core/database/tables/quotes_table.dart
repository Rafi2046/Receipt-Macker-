import 'package:drift/drift.dart';

import 'business_profiles_table.dart';
import 'clients_table.dart';

@DataClassName('QuoteRow')
class QuotesTable extends Table {
  @override
  String get tableName => 'quotes';

  TextColumn get id => text()();
  TextColumn get profileId => text().references(BusinessProfilesTable, #id)();
  TextColumn get number => text()();
  TextColumn get clientId => text().nullable().references(
    ClientsTable,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get billToName => text().nullable()();
  TextColumn get billToPhone => text().withDefault(const Constant(''))();
  TextColumn get billToEmail => text().withDefault(const Constant(''))();
  TextColumn get billToAddress => text().withDefault(const Constant(''))();
  TextColumn get currencyCode => text()();
  IntColumn get issueDate => integer()();
  IntColumn get validUntil => integer()();

  /// `pending`, `approved`, or `rejected`.
  TextColumn get status => text()();
  TextColumn get discountType => text().nullable()();
  IntColumn get discountValue => integer().nullable()();
  IntColumn get taxRateBasisPoints => integer().nullable()();
  BoolColumn get taxInclusive => boolean().withDefault(const Constant(false))();
  IntColumn get shippingMinor => integer().withDefault(const Constant(0))();
  IntColumn get totalMinor => integer()();
  TextColumn get notes => text().withDefault(const Constant(''))();
  TextColumn get terms => text().withDefault(const Constant(''))();
  TextColumn get paymentInstructions =>
      text().withDefault(const Constant(''))();
  TextColumn get convertedInvoiceId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {profileId, number},
  ];
}
