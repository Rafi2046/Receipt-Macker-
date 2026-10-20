import '../../../../core/errors/result.dart';
import '../models/payment.dart';

abstract interface class PaymentRepository {
  /// Payments on [invoiceId], oldest first. Empty after the invoice is
  /// deleted (they cascade with it).
  Stream<List<Payment>> watchForInvoice(String invoiceId);

  /// Fails with `NotFoundFailure` when there is no payment with [id].
  Future<Result<Payment>> find(String id);

  /// Inserts or updates. A new payment gets the next receipt number.
  /// Fails with `NotFoundFailure` when the invoice is gone, and with
  /// `ValidationFailure` when the amount is not allowed.
  Future<Result<Payment>> save(Payment payment);

  /// Removes the payment and recomputes the invoice's paid amount.
  /// The receipt number is not reused.
  Future<Result<void>> delete(String id);
}
