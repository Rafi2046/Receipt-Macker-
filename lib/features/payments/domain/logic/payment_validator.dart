import '../../../../core/utils/money.dart';
import '../../../../core/utils/validation_error.dart';
import '../../../../core/utils/validators.dart';
import '../models/payment.dart';
import '../models/payment_field.dart';

/// Checks a payment before it is stored. [maxMinor] is the most this
/// payment may be: the balance due, plus this payment's current amount
/// when it is being edited. Overpayment is rejected.
abstract final class PaymentValidator {
  static Map<PaymentField, ValidationError> validate(
    Payment payment, {
    required int maxMinor,
  }) {
    final errors = <PaymentField, ValidationError?>{
      PaymentField.amount: amount(
        amountMinor: payment.amountMinor,
        maxMinor: maxMinor,
      ),
      PaymentField.note: Validators.optionalText(payment.note),
    };
    return {for (final MapEntry(:key, :value) in errors.entries) key: ?value};
  }

  static ValidationError? amount({
    required int amountMinor,
    required int maxMinor,
  }) {
    if (amountMinor <= 0) return ValidationError.mustBePositive;
    if (amountMinor.abs() >= Money.maxMinor) {
      return ValidationError.amountTooLarge;
    }
    if (amountMinor > maxMinor) return ValidationError.amountAboveBalance;
    return null;
  }
}
