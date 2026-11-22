/// Why a field value is not accepted. Views map these to localized messages.
enum ValidationError {
  required,
  tooLong,
  invalidEmail,
  invalidPhone,
  invalidUrl,
  percentTooHigh,

  /// Must be more than zero (e.g. a quantity).
  mustBePositive,

  /// Above the largest supported amount.
  amountTooLarge,

  /// More than the invoice's remaining balance.
  amountAboveBalance,

  /// An invoice total below what was already paid on it.
  belowPaid,

  /// A flat discount bigger than what it applies to.
  discountTooLarge,
  dueBeforeIssue,
  noLines,

  /// Another invoice already uses this number.
  numberTaken,
}
