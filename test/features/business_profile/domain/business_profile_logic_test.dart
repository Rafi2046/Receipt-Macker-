import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/business_profile/domain/logic/business_profile_validator.dart';
import 'package:receipt_maker/features/business_profile/domain/logic/profile_field_access.dart';
import 'package:receipt_maker/features/business_profile/domain/logic/profile_image_editor.dart';
import 'package:receipt_maker/features/business_profile/domain/models/business_profile.dart';
import 'package:receipt_maker/features/business_profile/domain/models/profile_field.dart';
import 'package:receipt_maker/features/business_profile/domain/models/profile_image_kind.dart';
import 'package:receipt_maker/features/business_profile/domain/repositories/business_profile_repository.dart';

import '../../../helpers/test_env.dart';

class _MockRepo extends Mock implements BusinessProfileRepository {}

void main() {
  setUpAll(() => registerFallbackValue(Uint8List(0)));

  final t = DateTime.utc(2026, 10, 20);
  final empty = BusinessProfile(id: 'p', name: '', createdAt: t, updatedAt: t);

  group('BusinessProfileValidator', () {
    test('only the name is required', () {
      expect(BusinessProfileValidator.validate(empty), {
        ProfileField.name: ValidationError.required,
      });
      expect(
        BusinessProfileValidator.validate(
          empty.copyWith(name: 'Rahman Traders'),
        ),
        isEmpty,
      );
    });

    test('reports each invalid optional field', () {
      final p = empty.copyWith(
        name: 'Shop',
        email: 'x@',
        phone: '12',
        website: 'nope',
      );
      expect(BusinessProfileValidator.validate(p).keys, {
        ProfileField.email,
        ProfileField.phone,
        ProfileField.website,
      });
    });
  });

  group('ProfileFieldAccess', () {
    test('reads and writes every field', () {
      for (final f in ProfileField.values) {
        expect(empty.withField(f, 'v-${f.name}').valueOf(f), 'v-${f.name}');
      }
    });

    test('sameContentAs ignores timestamps only', () {
      final later = empty.copyWith(updatedAt: t.add(const Duration(days: 1)));
      expect(later.sameContentAs(empty), isTrue);
      expect(later.copyWith(name: 'x').sameContentAs(empty), isFalse);
      expect(empty.sameContentAs(null), isFalse);
    });
  });

  group('ProfileImageEditor', () {
    late _MockRepo repo;
    late ProfileImageEditor editor;

    setUp(() {
      repo = _MockRepo();
      editor = ProfileImageEditor(repo);
      when(() => repo.deleteImage(any()))
          .thenAnswer((_) async => const Ok(null));
      when(
        () => repo.storeImage(
          ProfileImageKind.logo,
          any(),
          extension: any(named: 'extension'),
        ),
      ).thenAnswer((_) async => const Ok('images/logo_new.png'));
    });

    test('replacing an unsaved draft deletes it', () async {
      final r = await editor.replace(
        ProfileImageKind.logo,
        tinyPng,
        extension: 'png',
        current: 'draft.png',
        persisted: 'saved.png',
      );
      expect(r.valueOrNull, 'images/logo_new.png');
      verify(() => repo.deleteImage('draft.png')).called(1);
    });

    test('replacing the saved image keeps it until save', () async {
      await editor.replace(
        ProfileImageKind.logo,
        tinyPng,
        extension: 'png',
        current: 'saved.png',
        persisted: 'saved.png',
      );
      verifyNever(() => repo.deleteImage(any()));
    });

    test('afterSave deletes the replaced saved image', () async {
      await editor.afterSave(
        previous: 'saved.png',
        saved: 'images/logo_new.png',
      );
      await editor.afterSave(previous: 'same.png', saved: 'same.png');
      verify(() => repo.deleteImage('saved.png')).called(1);
      verifyNever(() => repo.deleteImage('same.png'));
    });
  });
}
