import 'package:drift/drift.dart';

import 'business_profiles_table.dart';
import 'invoices_table.dart';

/// One recorded payment. Money is integer minor units of the invoice's
/// currency. [paidOn] is a calendar day (`yyyymmdd`). [receiptNumber] is
/// assigned once and never reused.
@DataClassName('PaymentRow')
class PaymentsTable extends Table {
  @override
  String get tableName => 'payments';

  TextColumn get id => text()();
  TextColumn get profileId => text().references(BusinessProfilesTable, #id)();
  TextColumn get invoiceId =>
      text().references(InvoicesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get amountMinor => integer()();
  IntColumn get paidOn => integer()();

  /// A [PaymentMethod] name.
  TextColumn get method => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get receiptNumber => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {profileId, receiptNumber},
  ];
}
