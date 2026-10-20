import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/core/utils/validators.dart';

void main() {
  test('requiredText', () {
    expect(Validators.requiredText(''), ValidationError.required);
    expect(Validators.requiredText('   '), ValidationError.required);
    expect(Validators.requiredText('Rahman Traders'), isNull);
    expect(Validators.requiredText('রহমান ট্রেডার্স'), isNull);
    expect(Validators.requiredText('x' * 121), ValidationError.tooLong);
  });

  test('optionalEmail', () {
    expect(Validators.optionalEmail(''), isNull);
    expect(Validators.optionalEmail('name@example.com'), isNull);
    expect(Validators.optionalEmail(' name@shop.com.bd '), isNull);
    expect(Validators.optionalEmail('name@'), ValidationError.invalidEmail);
    expect(
      Validators.optionalEmail('name example.com'),
      ValidationError.invalidEmail,
    );
  });

  test('optionalPhone accepts common BD and international formats', () {
    for (final ok in [
      '',
      '01712-345678',
      '+880 1712 345678',
      '(02) 9876543',
      '০১৭১২৩৪৫৬৭৮',
    ]) {
      expect(Validators.optionalPhone(ok), isNull, reason: ok);
    }
    for (final bad in [
      '12345',
      'call me',
      '+880-1712-345678-999999',
      '017a2345678',
    ]) {
      expect(
        Validators.optionalPhone(bad),
        ValidationError.invalidPhone,
        reason: bad,
      );
    }
  });

  test('optionalUrl', () {
    for (final ok in [
      '',
      'example.com',
      'https://shop.example.com.bd/about',
      'www.facebook.com/myshop',
    ]) {
      expect(Validators.optionalUrl(ok), isNull, reason: ok);
    }
    for (final bad in ['not a url', 'example', 'http://']) {
      expect(
        Validators.optionalUrl(bad),
        ValidationError.invalidUrl,
        reason: bad,
      );
    }
  });

  test('optionalText length limit', () {
    expect(Validators.optionalText('x' * 2000), isNull);
    expect(Validators.optionalText('x' * 2001), ValidationError.tooLong);
  });
}
