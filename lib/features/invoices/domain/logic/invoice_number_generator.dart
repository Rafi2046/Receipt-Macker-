/// Invoice numbers like `INV-0001`: a prefix and a zero-padded sequence.
abstract final class InvoiceNumberGenerator {
  static final RegExp _digits = RegExp(r'^\d+$');

  static String format(String prefix, int sequence, {required int padding}) =>
      '$prefix${'$sequence'.padLeft(padding, '0')}';

  /// The sequence in [number] when it is [prefix] followed by digits,
  /// e.g. 12 for `INV-0012`; null for any other number.
  static int? sequenceOf(String prefix, String number) {
    if (!number.startsWith(prefix)) return null;
    final rest = number.substring(prefix.length);
    return _digits.hasMatch(rest) ? int.tryParse(rest) : null;
  }

  /// The next sequence to suggest after [saved] is stored. Only moves
  /// forward, so deleting an invoice never frees its number for reuse, and
  /// a hand-typed number further ahead (`INV-0100`) skips past it.
  static int nextAfterSaving(int next, String prefix, String saved) {
    final used = sequenceOf(prefix, saved);
    return used != null && used >= next ? used + 1 : next;
  }
}
