import 'package:drift/drift.dart';

/// Saved clients (buyers). Phone digits are stored in Latin form.
@DataClassName('ClientRow')
class ClientsTable extends Table {
  @override
  String get tableName => 'clients';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text().withDefault(const Constant(''))();
  TextColumn get email => text().withDefault(const Constant(''))();

  /// Billing address line 1 (shown on invoices as the client address).
  TextColumn get address => text().withDefault(const Constant(''))();
  TextColumn get addressLine2 => text().withDefault(const Constant(''))();
  TextColumn get shippingAddress => text().withDefault(const Constant(''))();
  TextColumn get shippingAddressLine2 =>
      text().withDefault(const Constant(''))();
  TextColumn get taxRegistrationName =>
      text().withDefault(const Constant(''))();
  TextColumn get taxRegistrationNumber =>
      text().withDefault(const Constant(''))();
  TextColumn get licenseNumber => text().withDefault(const Constant(''))();

  /// Private notes / client detail, never printed.
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
