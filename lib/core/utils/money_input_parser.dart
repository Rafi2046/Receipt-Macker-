/// Converts what the user types in an amount field to integer minor units
/// and back. Accepts Latin or Bangla digits, grouping commas and spaces.
/// Never goes through `double`.
abstract final class MoneyInputParser {
  static const int maxWholeDigits = 13;
  static const String _bnDigits = '০১২৩৪৫৬৭৮৯';

  /// `"1,234.5"` with 2 decimals gives `123450`. Returns null when empty or
  /// invalid (letters, two separators, too many decimals or digits).
  static int? parse(String input, {required int decimalDigits}) {
    final text = normalize(input).replaceAll(RegExp(r'[,\s]'), '');
    if (text.isEmpty || text == '.') return null;
    final match = RegExp(r'^(\d*)(?:\.(\d*))?$').firstMatch(text);
    if (match == null) return null;
    final whole = match.group(1) ?? '';
    if (decimalDigits == 0 && match.group(2) != null) return null;
    final fraction = match.group(2) ?? '';
    if (fraction.length > decimalDigits) return null;
    if (whole.length > maxWholeDigits) return null;
    final paddedFraction = fraction.padRight(decimalDigits, '0');
    return int.parse('${whole.isEmpty ? '0' : whole}$paddedFraction');
  }

  /// Editable text for [minor]: `123450` with 2 decimals gives `"1234.50"`.
  /// No grouping, Latin digits, so the user can edit it directly.
  static String format(int minor, {required int decimalDigits}) {
    final negative = minor < 0;
    final digits = minor.abs().toString().padLeft(decimalDigits + 1, '0');
    final split = digits.length - decimalDigits;
    final whole = digits.substring(0, split);
    final sign = negative ? '-' : '';
    if (decimalDigits == 0) return '$sign$whole';
    return '$sign$whole.${digits.substring(split)}';
  }

  /// Drops fraction digits beyond [decimalDigits] (and the `.` when 0),
  /// used when the currency changes under typed text.
  static String clampFraction(String text, {required int decimalDigits}) {
    final dot = text.indexOf('.');
    if (dot < 0) return text;
    if (decimalDigits == 0) return text.substring(0, dot);
    final end = dot + 1 + decimalDigits;
    return end >= text.length ? text : text.substring(0, end);
  }

  /// Replaces Bangla digits with Latin ones.
  static String normalize(String input) {
    final out = StringBuffer();
    for (final ch in input.split('')) {
      final i = _bnDigits.indexOf(ch);
      out.write(i >= 0 ? '$i' : ch);
    }
    return out.toString();
  }
}
