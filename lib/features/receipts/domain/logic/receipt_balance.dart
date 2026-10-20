import '../../../payments/domain/models/payment.dart';

/// Balance still owed after [paymentId], counting that payment and every
/// earlier one (by date, then by when it was recorded).
int balanceAfterPayment({
  required int totalMinor,
  required List<Payment> payments,
  required String paymentId,
}) {
  final ordered = [...payments]
    ..sort((a, b) {
      final byDate = a.paidOn.compareTo(b.paidOn);
      return byDate != 0 ? byDate : a.createdAt.compareTo(b.createdAt);
    });
  var running = 0;
  for (final payment in ordered) {
    running += payment.amountMinor;
    if (payment.id == paymentId) return totalMinor - running;
  }
  return totalMinor - running;
}
