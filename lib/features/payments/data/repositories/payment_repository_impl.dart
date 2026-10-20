import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/invoice_dao.dart';
import '../../../../core/database/daos/payment_dao.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/logic/payment_validator.dart';
import '../../domain/logic/receipt_number_generator.dart';
import '../../domain/models/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../mappers/payment_mapper.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._db, this._payments, this._invoices);

  final AppDatabase _db;
  final PaymentDao _payments;
  final InvoiceDao _invoices;

  static Failure _dbFailure(Object e, StackTrace s) =>
      e is Failure ? e : DatabaseFailure(cause: e, stackTrace: s);

  @override
  Stream<List<Payment>> watchForInvoice(String invoiceId) => _payments
      .watchForInvoice(invoiceId)
      .map((rows) => [for (final r in rows) r.toDomain()]);

  @override
  Future<Result<Payment>> find(String id) => Result.guard(() async {
    final row = await _payments.findById(id);
    if (row == null) throw const NotFoundFailure();
    return row.toDomain();
  }, onError: _dbFailure);

  @override
  Future<Result<Payment>> save(Payment payment) => Result.guard(
    () => _db.transaction(() async {
      final invoice = await _invoices.findById(payment.invoiceId);
      if (invoice == null) throw const NotFoundFailure();
      final existing = await _payments.findById(payment.id);
      final others = await _payments.amountsExcept(
        payment.invoiceId,
        exceptId: payment.id,
      );
      final paidByOthers = others.fold<int>(0, (sum, a) => sum + a);
      final max = invoice.totalMinor - paidByOthers;
      final errors = PaymentValidator.validate(payment, maxMinor: max);
      if (errors.isNotEmpty) {
        throw ValidationFailure(errors.keys.first.name);
      }
      final number =
          existing?.receiptNumber ??
          await _allocateReceiptNumber(invoice.profileId);
      final row = payment.toRow(
        profileId: invoice.profileId,
        receiptNumber: number,
      );
      await _payments.upsert(row);
      await _invoices.setPaidMinor(
        invoice.id,
        paidByOthers + payment.amountMinor,
      );
      return row.toDomain();
    }),
    onError: _dbFailure,
  );

  @override
  Future<Result<void>> delete(String id) => Result.guard(
    () => _db.transaction(() async {
      final existing = await _payments.findById(id);
      if (existing == null) throw const NotFoundFailure();
      await _payments.deleteById(id);
      final others = await _payments.amountsExcept(
        existing.invoiceId,
        exceptId: id,
      );
      final paid = others.fold<int>(0, (sum, a) => sum + a);
      await _invoices.setPaidMinor(existing.invoiceId, paid);
    }),
    onError: _dbFailure,
  );

  Future<String> _allocateReceiptNumber(String profileId) async {
    final numbering =
        await _payments.numberingOf(profileId) ??
        ReceiptNumberingRow(
          profileId: profileId,
          prefix: AppConstants.defaultReceiptPrefix,
          nextSequence: 1,
        );
    final number = ReceiptNumberGenerator.format(
      numbering.prefix,
      numbering.nextSequence,
      padding: AppConstants.receiptNumberPadding,
    );
    final next = ReceiptNumberGenerator.nextAfterSaving(
      numbering.nextSequence,
      numbering.prefix,
      number,
    );
    await _payments.upsertNumbering(numbering.copyWith(nextSequence: next));
    return number;
  }
}
