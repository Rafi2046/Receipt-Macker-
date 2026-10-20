import 'package:drift/drift.dart';

import 'business_profiles_table.dart';
import 'clients_table.dart';

/// Invoices. Money is integer minor units of [currencyCode]; dates are
/// calendar days as `yyyymmdd`; [billToName] etc. are a copy of the client
/// at the time. [totalMinor] is stored for lists and the dashboard and is
/// recomputed on every save.
@DataClassName('InvoiceRow')
class InvoicesTable extends Table {
  @override
  String get tableName => 'invoices';

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
  IntColumn get dueDate => integer()();

  /// `draft` or `sent`.
  TextColumn get stage => text()();

  /// `percent` or `flat`, null for no discount.
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
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {profileId, number},
  ];
}
