import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/constants/app_currencies.dart';

void main() {
  test('every listed currency has a flag and a name', () {
    for (final code in AppCurrencies.common) {
      expect(AppCurrencies.flag(code), isNot(equals('🏳️')), reason: code);
      expect(AppCurrencies.name(code), isNot(equals(code)), reason: code);
    }
  });

  test('Bangladesh and US flags are correct', () {
    expect(AppCurrencies.flag('BDT'), '🇧🇩');
    expect(AppCurrencies.flag('USD'), '🇺🇸');
  });
}
