import 'money_input_parser.dart';
import 'validation_error.dart';

/// Pure field validators. Each returns null when the value is acceptable.
/// "optional" validators accept an empty value.
abstract final class Validators {
  static const int maxShortText = 120;
  static const int maxLongText = 2000;
  static const int minPhoneDigits = 6;
  static const int maxPhoneDigits = 15;

  /// 100% in basis points.
  static const int maxBasisPoints = 10000;

  static final RegExp _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');
  static final RegExp _phoneChars = RegExp(r'^\+?[\d\s\-().]+$');
  static final RegExp _url = RegExp(
    r'^(https?://)?([a-z0-9-]+\.)+[a-z]{2,}(/\S*)?$',
    caseSensitive: false,
  );

  static ValidationError? requiredText(String value, {int max = maxShortText}) {
    final text = value.trim();
    if (text.isEmpty) return ValidationError.required;
    return text.length > max ? ValidationError.tooLong : null;
  }

  static ValidationError? optionalText(String value, {int max = maxLongText}) =>
      value.trim().length > max ? ValidationError.tooLong : null;

  static ValidationError? optionalEmail(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;
    return _email.hasMatch(text) ? null : ValidationError.invalidEmail;
  }

  /// Accepts Latin or Bangla digits, spaces, dashes, brackets and a leading +.
  static ValidationError? optionalPhone(String value) {
    final text = MoneyInputParser.normalize(value.trim());
    if (text.isEmpty) return null;
    final digits = text.replaceAll(RegExp(r'\D'), '').length;
    final ok =
        _phoneChars.hasMatch(text) &&
        digits >= minPhoneDigits &&
        digits <= maxPhoneDigits;
    return ok ? null : ValidationError.invalidPhone;
  }

  static ValidationError? optionalUrl(String value) {
    final text = value.trim();
    if (text.isEmpty) return null;
    return _url.hasMatch(text) ? null : ValidationError.invalidUrl;
  }

  /// A money amount in minor units must be entered (zero is allowed).
  static ValidationError? requiredAmount(int? minor) =>
      minor == null ? ValidationError.required : null;

  /// Empty (null) or 0-100%, in basis points.
  static ValidationError? optionalPercent(int? basisPoints) =>
      (basisPoints ?? 0) > maxBasisPoints
      ? ValidationError.percentTooHigh
      : null;
}
