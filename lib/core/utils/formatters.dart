import 'package:intl/intl.dart';

/// Locale-aware number and date formatting.
///
/// Bangla (`bn`) output uses Bangla digits (০-৯) and Indian grouping (১২,৩৪,৫৬৭);
/// English uses Latin digits. Call `initializeDateFormatting()` once at startup
/// (done in bootstrap) before formatting dates.
class AppFormatters {
  AppFormatters(this.languageCode)
    : _integer = NumberFormat.decimalPattern(languageCode),
      _zeroDigit = NumberFormat.decimalPattern(languageCode).symbols.ZERO_DIGIT;

  final String languageCode;
  final NumberFormat _integer;
  final String _zeroDigit;

  static const int _latinZero = 0x30;

  /// Grouped integer, e.g. `1,234,567` (en) or `১২,৩৪,৫৬৭` (bn).
  String integer(int value) => _integer.format(value);

  /// Fixed-point value from integer minor units, e.g. 123456 with 2 decimals
  /// gives `1,234.56`. Never goes through `double`, so no rounding drift.
  String minorUnits(int minor, {required int decimalDigits}) {
    assert(decimalDigits >= 0, 'decimalDigits must not be negative');
    final negative = minor < 0;
    final digits = minor.abs().toString().padLeft(decimalDigits + 1, '0');
    final split = digits.length - decimalDigits;
    final whole = _integer.format(int.parse(digits.substring(0, split)));
    final sign = negative ? _integer.symbols.MINUS_SIGN : '';
    if (decimalDigits == 0) return '$sign$whole';
    final fraction = localizeDigits(digits.substring(split));
    return '$sign$whole${_integer.symbols.DECIMAL_SEP}$fraction';
  }

  /// Medium date in local time, e.g. `Oct 20, 2026` / `২০ অক্টো, ২০২৬`.
  String date(DateTime value) =>
      DateFormat.yMMMd(languageCode).format(value.toLocal());

  /// Replaces Latin digits in [text] with this locale's digits.
  String localizeDigits(String text) {
    final zero = _zeroDigit.codeUnitAt(0);
    if (zero == _latinZero) return text;
    final out = StringBuffer();
    for (final unit in text.codeUnits) {
      final isDigit = unit >= _latinZero && unit <= _latinZero + 9;
      out.writeCharCode(isDigit ? zero + unit - _latinZero : unit);
    }
    return out.toString();
  }
}
