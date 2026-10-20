import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/money_input_parser.dart';

void main() {
  group('parse', () {
    int? p(String s, [int d = 2]) =>
        MoneyInputParser.parse(s, decimalDigits: d);

    test('whole and fractional amounts', () {
      expect(p('12'), 1200);
      expect(p('12.5'), 1250);
      expect(p('12.50'), 1250);
      expect(p('0.05'), 5);
      expect(p('.5'), 50);
      expect(p('12.'), 1200);
    });

    test('grouping and spaces are ignored', () {
      expect(p('1,234.56'), 123456);
      expect(p('1,23,456'), 12345600);
      expect(p(' 1 000 '), 100000);
    });

    test('Bangla digits', () {
      expect(p('১২৩.৪৫'), 12345);
      expect(p('১,২৩,৪৫৬'), 12345600);
    });

    test('zero-decimal currencies', () {
      expect(p('1500', 0), 1500);
      expect(p('1500.5', 0), isNull);
      expect(p('1500.', 0), isNull);
    });

    test('invalid input gives null', () {
      expect(p(''), isNull);
      expect(p('.'), isNull);
      expect(p('abc'), isNull);
      expect(p('1.2.3'), isNull);
      expect(p('1.234'), isNull);
      expect(p('-5'), isNull);
      expect(p('1' * 14), isNull);
    });

    test('largest allowed value fits in int', () {
      expect(p('9' * 13), 999999999999900);
    });
  });

  group('format', () {
    test('round-trips with parse', () {
      for (final minor in [0, 5, 50, 1250, 123456, 999999999999900]) {
        final text = MoneyInputParser.format(minor, decimalDigits: 2);
        expect(MoneyInputParser.parse(text, decimalDigits: 2), minor);
      }
    });

    test('shapes', () {
      expect(MoneyInputParser.format(1250, decimalDigits: 2), '12.50');
      expect(MoneyInputParser.format(5, decimalDigits: 2), '0.05');
      expect(MoneyInputParser.format(1500, decimalDigits: 0), '1500');
      expect(MoneyInputParser.format(-5, decimalDigits: 2), '-0.05');
    });
  });

  test('clampFraction', () {
    expect(MoneyInputParser.clampFraction('12.50', decimalDigits: 0), '12');
    expect(MoneyInputParser.clampFraction('12.505', decimalDigits: 2), '12.50');
    expect(MoneyInputParser.clampFraction('12.5', decimalDigits: 2), '12.5');
    expect(MoneyInputParser.clampFraction('12', decimalDigits: 2), '12');
  });
}
