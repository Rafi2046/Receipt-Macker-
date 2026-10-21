import 'package:intl/intl.dart';

import 'calendar_date.dart';
import 'money_input_parser.dart';

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

  /// Amount with currency symbol. A whole amount omits the fraction
  /// (`৳26,500`); a fractional one keeps it (`৳1,234.50`, `৳0.05`).
  /// Zero-decimal currencies stay whole (`¥1,500`). A negative amount puts
  /// the sign first: `-৳820`.
  String currency(int minor, String currencyCode) {
    final digits = currencyDecimalDigits(currencyCode);
    final unit = _pow10(digits);
    final absMinor = minor.abs();
    final whole = digits > 0 && absMinor % unit == 0;
    final amount = minorUnits(
      whole ? absMinor ~/ unit : absMinor,
      decimalDigits: whole ? 0 : digits,
    );
    final sign = minor < 0 ? _integer.symbols.MINUS_SIGN : '';
    return '$sign${currencySymbol(currencyCode)}$amount';
  }

  /// Fixed-point [scaled] value with up to [decimalDigits] decimals and no
  /// trailing zeros, e.g. 1500 with 3 digits gives `1.5` (`১.৫` in Bangla).
  String compactDecimal(int scaled, {required int decimalDigits}) {
    final fixed = minorUnits(scaled, decimalDigits: decimalDigits);
    return MoneyInputParser.trimFraction(
      fixed,
      _zeroDigit,
      _integer.symbols.DECIMAL_SEP,
    );
  }

  /// Percentage from basis points without trailing zeros, e.g. 1500 gives
  /// `15%` and 750 gives `7.5%` (`৭.৫%` in Bangla).
  String percent(int basisPoints) =>
      '${compactDecimal(basisPoints, decimalDigits: percentDecimalDigits)}'
      '${_integer.symbols.PERCENT}';

  /// Quantity from thousandths, e.g. 2500 gives `2.5`.
  String quantity(int quantityMilli) =>
      compactDecimal(quantityMilli, decimalDigits: quantityDecimalDigits);

  /// Basis points carry two decimals of a percent.
  static const int percentDecimalDigits = 2;

  /// Quantities are stored in thousandths.
  static const int quantityDecimalDigits = 3;

  /// ISO 4217 minor-unit digits: 2 for BDT/USD, 0 for JPY.
  static int currencyDecimalDigits(String currencyCode) =>
      NumberFormat.currency(name: currencyCode).decimalDigits ?? 2;

  static int _pow10(int digits) {
    var unit = 1;
    for (var i = 0; i < digits; i++) {
      unit *= 10;
    }
    return unit;
  }

  /// Short symbol (`৳`, `\$`, `¥`); falls back to the ISO code.
  static String currencySymbol(String currencyCode) =>
      NumberFormat.simpleCurrency(name: currencyCode).currencySymbol;

  /// Medium date for a calendar day (issue or due date), e.g. `Oct 20, 2026`.
  String calendarDate(CalendarDate value) =>
      DateFormat.yMMMd(languageCode).format(value.toLocalDateTime());

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
