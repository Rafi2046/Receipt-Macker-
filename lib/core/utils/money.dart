/// An amount in integer minor units (poisha, cents; yen has none) of one
/// currency. Never a `double`. Scaling rounds half away from zero, which is
/// half-up for the non-negative amounts invoices use.
class Money implements Comparable<Money> {
  const Money(this.minor, this.currencyCode);

  const Money.zero(this.currencyCode) : minor = 0;

  final int minor;
  final String currencyCode;

  /// Basis points per whole (10000 = 100%).
  static const int basisPointsPerWhole = 10000;

  /// Quantities are stored in thousandths (1500 = 1.5).
  static const int quantityScale = 1000;

  /// Largest amount handled: 15 digits, what an amount field accepts
  /// (13 whole digits and 2 decimals). Scaling saturates here so totals of
  /// absurd input stay in range; validation rejects amounts that reach it.
  static const int maxMinor = 999999999999999;

  bool get isZero => minor == 0;

  Money operator +(Money other) => Money(minor + _same(other), currencyCode);

  Money operator -(Money other) => Money(minor - _same(other), currencyCode);

  /// `minor × numerator ÷ denominator`, rounded half-up. Uses BigInt so a
  /// large price times a large quantity cannot overflow.
  Money scale(int numerator, int denominator) =>
      Money(divideHalfUp(minor, numerator, denominator), currencyCode);

  /// Price × quantity, where [quantityMilli] is in thousandths.
  Money timesQuantity(int quantityMilli) => scale(quantityMilli, quantityScale);

  /// [basisPoints] of this amount (1500 = 15%).
  Money percent(int basisPoints) => scale(basisPoints, basisPointsPerWhole);

  Money clamp(Money low, Money high) =>
      Money(minor.clamp(_same(low), _same(high)), currencyCode);

  /// `a × b ÷ d` rounded half away from zero, limited to ±[maxMinor].
  static int divideHalfUp(int a, int b, int d) {
    assert(d != 0, 'division by zero');
    final n = BigInt.from(a) * BigInt.from(b);
    final den = BigInt.from(d);
    final negative = n.isNegative != den.isNegative;
    final q = (n.abs() * BigInt.two + den.abs()) ~/ (den.abs() * BigInt.two);
    final limited = q > _max ? _max : q;
    return (negative ? -limited : limited).toInt();
  }

  static final BigInt _max = BigInt.from(maxMinor);

  int _same(Money other) {
    if (other.currencyCode != currencyCode) {
      throw ArgumentError(
        'Currency mismatch: $currencyCode vs ${other.currencyCode}',
      );
    }
    return other.minor;
  }

  @override
  int compareTo(Money other) => minor.compareTo(_same(other));

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.minor == minor &&
      other.currencyCode == currencyCode;

  @override
  int get hashCode => Object.hash(minor, currencyCode);

  @override
  String toString() => 'Money($minor $currencyCode)';
}
