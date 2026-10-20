import '../../../l10n/gen/app_localizations.dart';
import '../validation_error.dart';

extension ValidationMessageX on AppLocalizations {
  /// Localized message for a field error; null when there is none.
  String? validationMessage(ValidationError? error) => switch (error) {
    null => null,
    ValidationError.required => validationRequired,
    ValidationError.tooLong => validationTooLong,
    ValidationError.invalidEmail => validationEmail,
    ValidationError.invalidPhone => validationPhone,
    ValidationError.invalidUrl => validationUrl,
    ValidationError.percentTooHigh => validationPercent,
    ValidationError.mustBePositive => validationPositive,
    ValidationError.amountTooLarge => validationAmountTooLarge,
    ValidationError.discountTooLarge => validationDiscountTooLarge,
    ValidationError.dueBeforeIssue => validationDueBeforeIssue,
    ValidationError.noLines => validationNoLines,
    ValidationError.numberTaken => validationNumberTaken,
  };
}
