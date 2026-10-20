import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/money.dart';

void main() {
  const bdt = 'BDT';
  Money m(int minor) => Money(minor, bdt);

  test('adds and subtracts in the same currency', () {
    expect(m(150) + m(250), m(400));
    expect(m(150) - m(250), m(-100));
  });

  test('refuses to mix currencies', () {
    expect(() => m(1) + const Money(1, 'USD'), throwsArgumentError);
  });

  test('percent rounds half-up', () {
    expect(m(1000).percent(1500), m(150));
    expect(m(1).percent(5000), m(1), reason: '0.5 rounds up');
    expect(m(3).percent(1667), m(1), reason: '0.5001 rounds up');
    expect(m(2).percent(2499), m(0), reason: '0.4998 rounds down');
  });

  test('quantity in thousandths', () {
    expect(m(12345).timesQuantity(1500), m(18518), reason: '18517.5 up');
    expect(m(999).timesQuantity(1), m(1), reason: '0.999 rounds to 1');
    expect(m(100).timesQuantity(0), m(0));
  });

  test('large price times large quantity saturates instead of overflowing', () {
    expect(m(999999999999999).timesQuantity(999999999), m(Money.maxMinor));
    expect(Money.divideHalfUp(-Money.maxMinor, 1000, 1), -Money.maxMinor);
  });

  test('scale stays exact below the limit', () {
    // 9,999,999.99 × 999.999 = 9,999,989,999.99000001
    expect(m(999999999).timesQuantity(999999), m(999998999000));
  });

  test('rounding is symmetric for negatives', () {
    expect(Money.divideHalfUp(-1, 1, 2), -1);
    expect(Money.divideHalfUp(-3, 1, 4), -1);
    expect(Money.divideHalfUp(-1, 1, 4), 0);
  });

  test('clamp keeps an amount within bounds', () {
    expect(m(500).clamp(m(0), m(300)), m(300));
    expect(m(-5).clamp(m(0), m(300)), m(0));
  });

  test('value equality includes currency', () {
    expect(m(1) == const Money(1, 'USD'), isFalse);
    expect(m(1).hashCode, m(1).hashCode);
  });
}
