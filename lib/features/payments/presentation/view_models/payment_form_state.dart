import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/utils/validation_error.dart';
import '../../domain/logic/payment_validator.dart';
import '../../domain/models/payment.dart';
import '../../domain/models/payment_field.dart';

part 'payment_form_state.freezed.dart';

/// The record/edit payment sheet. [maxMinor] is the most this payment may be.
@freezed
abstract class PaymentFormState with _$PaymentFormState {
  const factory PaymentFormState({
    required Payment draft,
    required int maxMinor,
    required String currencyCode,
    required bool isNew,
    @Default(false) bool showErrors,
    @Default(false) bool isSaving,
    Failure? failure,
  }) = _PaymentFormState;

  const PaymentFormState._();

  Map<PaymentField, ValidationError> get errors =>
      PaymentValidator.validate(draft, maxMinor: maxMinor);

  ValidationError? errorFor(PaymentField field) =>
      showErrors ? errors[field] : null;
}
