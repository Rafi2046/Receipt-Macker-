/// Receipt numbers like `RCPT-0001`. Deleting a payment never frees its
/// number. The sequence only moves forward.
abstract final class ReceiptNumberGenerator {
  static final RegExp _digits = RegExp(r'^\d+$');

  static String format(String prefix, int sequence, {required int padding}) =>
      '$prefix${'$sequence'.padLeft(padding, '0')}';

  static int? sequenceOf(String prefix, String number) {
    if (!number.startsWith(prefix)) return null;
    final rest = number.substring(prefix.length);
    return _digits.hasMatch(rest) ? int.tryParse(rest) : null;
  }

  static int nextAfterSaving(int next, String prefix, String saved) {
    final used = sequenceOf(prefix, saved);
    return used != null && used >= next ? used + 1 : next;
  }
}
