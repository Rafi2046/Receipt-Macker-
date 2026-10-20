import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/core/utils/formatters.dart';

void main() {
  setUpAll(initializeDateFormatting);

  group('English', () {
    final f = AppFormatters('en');

    test('integer uses Latin digits and western grouping', () {
      expect(f.integer(1234567), '1,234,567');
    });

    test('minorUnits formats without double', () {
      expect(f.minorUnits(123456, decimalDigits: 2), '1,234.56');
      expect(f.minorUnits(5, decimalDigits: 2), '0.05');
      expect(f.minorUnits(-5, decimalDigits: 2), '-0.05');
      expect(f.minorUnits(1500, decimalDigits: 0), '1,500');
    });

    test('localizeDigits leaves Latin digits alone', () {
      expect(f.localizeDigits('INV-0042'), 'INV-0042');
    });

    test('date', () {
      expect(f.date(DateTime(2026, 10, 20)), 'Oct 20, 2026');
    });
  });

  group('Bangla', () {
    final f = AppFormatters('bn');

    test('integer uses Bangla digits and Indian grouping', () {
      expect(f.integer(1234567), '১২,৩৪,৫৬৭');
      expect(f.integer(0), '০');
    });

    test('minorUnits uses Bangla digits in both parts', () {
      expect(f.minorUnits(12345678, decimalDigits: 2), '১,২৩,৪৫৬.৭৮');
      expect(f.minorUnits(7, decimalDigits: 2), '০.০৭');
    });

    test('localizeDigits converts every digit', () {
      expect(f.localizeDigits('INV-0123456789'), 'INV-০১২৩৪৫৬৭৮৯');
    });

    test('date uses Bangla digits', () {
      expect(f.date(DateTime(2026, 10, 20)), contains('২০২৬'));
      expect(f.date(DateTime(2026, 10, 20)), isNot(contains('2026')));
    });
  });

  group('currency', () {
    test('symbols and decimal digits', () {
      expect(AppFormatters.currencySymbol('BDT'), '৳');
      expect(AppFormatters.currencySymbol('USD'), r'$');
      expect(AppFormatters.currencyDecimalDigits('BDT'), 2);
      expect(AppFormatters.currencyDecimalDigits('JPY'), 0);
    });

    test('formats per language', () {
      expect(AppFormatters('en').currency(123450, 'BDT'), '৳1,234.50');
      expect(AppFormatters('bn').currency(12345600, 'BDT'), '৳১,২৩,৪৫৬.০০');
      expect(AppFormatters('en').currency(1500, 'JPY'), '¥1,500');
    });
  });
}
