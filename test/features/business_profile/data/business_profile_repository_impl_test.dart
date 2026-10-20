import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/image_storage_service.dart';
import 'package:receipt_maker/features/business_profile/data/repositories/business_profile_repository_impl.dart';
import 'package:receipt_maker/features/business_profile/domain/models/business_profile.dart';
import 'package:receipt_maker/features/business_profile/domain/models/profile_image_kind.dart';

import '../../../helpers/test_env.dart';

void main() {
  late TestEnv env;
  late BusinessProfileRepositoryImpl repo;
  final t = DateTime.utc(2026, 10, 20, 8);

  setUp(() {
    env = TestEnv();
    repo = BusinessProfileRepositoryImpl(
      env.db.businessProfileDao,
      ImageStorageService(() async => env.imagesRoot),
    );
  });
  tearDown(() => env.dispose());

  test('load is null before onboarding', () async {
    expect((await repo.load()).valueOrNull, isNull);
  });

  test('save trims text, round-trips, and keeps UTC dates', () async {
    final p = BusinessProfile(
      id: 'a',
      name: '  রহমান ট্রেডার্স ',
      phone: ' 01712345678 ',
      createdAt: t,
      updatedAt: t,
    );
    final saved = await repo.save(p);
    expect(saved, isA<Ok<BusinessProfile>>());

    final loaded = (await repo.load()).valueOrNull;
    expect(loaded?.name, 'রহমান ট্রেডার্স');
    expect(loaded?.phone, '01712345678');
    expect(loaded?.createdAt, t);
    expect(loaded?.createdAt.isUtc, isTrue);
  });

  test('save is an upsert and watch emits updates', () async {
    final p = BusinessProfile(id: 'a', name: 'One', createdAt: t, updatedAt: t);
    final names = repo.watch().map((p) => p?.name).take(3).toList();
    await Future<void>.delayed(Duration.zero);
    await repo.save(p);
    await repo.save(p.copyWith(name: 'Two'));
    expect(await names, [null, 'One', 'Two']);
  });

  test('stores, resolves and deletes images', () async {
    final stored = await repo.storeImage(
      ProfileImageKind.signature,
      tinyPng,
      extension: 'png',
    );
    final path = stored.valueOrNull!;
    expect(path, startsWith('images/signature_'));
    final file = File(await repo.resolveImagePath(path));
    expect(file.readAsBytesSync(), tinyPng);

    expect(await repo.deleteImage(path), isA<Ok<void>>());
    expect(file.existsSync(), isFalse);
    expect(
      await repo.deleteImage(path),
      isA<Ok<void>>(),
      reason: 'deleting twice is fine',
    );
  });
}
