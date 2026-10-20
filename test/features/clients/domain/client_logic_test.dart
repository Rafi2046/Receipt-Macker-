import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/clients/domain/logic/client_field_access.dart';
import 'package:receipt_maker/features/clients/domain/logic/client_validator.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/clients/domain/models/client_field.dart';

void main() {
  final t = DateTime.utc(2026, 10, 20);
  final blank = Client(id: 'c', name: '', createdAt: t, updatedAt: t);

  test('only the name is required', () {
    expect(ClientValidator.validate(blank), {
      ClientField.name: ValidationError.required,
    });
    expect(ClientValidator.validate(blank.copyWith(name: 'করিম')), isEmpty);
  });

  test('phone and email are checked when present', () {
    final c = blank.copyWith(name: 'A', phone: '12', email: 'nope');
    expect(ClientValidator.validate(c), {
      ClientField.phone: ValidationError.invalidPhone,
      ClientField.email: ValidationError.invalidEmail,
    });
    final ok = blank.copyWith(name: 'A', phone: '০১৭১২৩৪৫৬৭৮');
    expect(ClientValidator.validate(ok), isEmpty);
  });

  test('every field can be read and written by ClientField', () {
    var c = blank;
    for (final field in ClientField.values) {
      c = c.withField(field, field.name);
    }
    for (final field in ClientField.values) {
      expect(c.valueOf(field), field.name);
    }
  });

  test('sameContentAs ignores timestamps', () {
    final later = blank.copyWith(updatedAt: t.add(const Duration(days: 1)));
    expect(later.sameContentAs(blank), isTrue);
    expect(blank.copyWith(name: 'x').sameContentAs(blank), isFalse);
  });
}
