import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/payments_table.dart';
import '../tables/receipt_numbering_table.dart';

part 'payment_dao.g.dart';

@DriftAccessor(tables: [PaymentsTable, ReceiptNumberingTable])
class PaymentDao extends DatabaseAccessor<AppDatabase> with _$PaymentDaoMixin {
  PaymentDao(super.attachedDatabase);

  /// Oldest payment date first, then the order they were recorded.
  Stream<List<PaymentRow>> watchForInvoice(String invoiceId) =>
      (_forInvoice(invoiceId)..orderBy([
            (t) => OrderingTerm.asc(t.paidOn),
            (t) => OrderingTerm.asc(t.createdAt),
          ]))
          .watch();

  SimpleSelectStatement<$PaymentsTableTable, PaymentRow> _forInvoice(
    String invoiceId,
  ) => select(paymentsTable)..where((t) => t.invoiceId.equals(invoiceId));

  Future<PaymentRow?> findById(String id) =>
      (select(paymentsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Amounts of every payment on [invoiceId] except [exceptId].
  Future<List<int>> amountsExcept(
    String invoiceId, {
    required String exceptId,
  }) {
    final query = selectOnly(paymentsTable)
      ..addColumns([paymentsTable.amountMinor])
      ..where(
        paymentsTable.invoiceId.equals(invoiceId) &
            paymentsTable.id.equals(exceptId).not(),
      );
    return query.map((row) => row.read(paymentsTable.amountMinor)!).get();
  }

  Future<void> upsert(PaymentRow row) =>
      into(paymentsTable).insertOnConflictUpdate(row);

  Future<int> deleteById(String id) =>
      (delete(paymentsTable)..where((t) => t.id.equals(id))).go();

  Future<ReceiptNumberingRow?> numberingOf(String profileId) => (select(
    receiptNumberingTable,
  )..where((t) => t.profileId.equals(profileId))).getSingleOrNull();

  Future<void> upsertNumbering(ReceiptNumberingRow row) =>
      into(receiptNumberingTable).insertOnConflictUpdate(row);
}
