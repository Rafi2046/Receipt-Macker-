import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/database/app_database.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/features/clients/data/repositories/client_repository_impl.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';

void main() {
  late AppDatabase db;
  late ClientRepositoryImpl repo;
  final t = DateTime.utc(2026, 10, 20, 8);

  Client client(
    String id,
    String name, {
    String phone = '',
    String email = '',
  }) => Client(
    id: id,
    name: name,
    phone: phone,
    email: email,
    createdAt: t,
    updatedAt: t,
  );

  Future<List<String>> names({String query = ''}) async =>
      (await repo.watchAll(query: query).first).map((c) => c.name).toList();

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repo = ClientRepositoryImpl(db.clientDao);
  });
  tearDown(() => db.close());

  test('save trims text, stores Latin phone digits, keeps UTC', () async {
    final saved = await repo.save(
      client('a', '  রহমান ট্রেডার্স ', phone: ' ০১৭১২-৩৪৫৬৭৮ '),
    );
    final value = (saved as Ok<Client>).value;
    expect(value.name, 'রহমান ট্রেডার্স');
    expect(value.phone, '01712-345678');

    final found = (await repo.find('a')).valueOrNull;
    expect(found, value);
    expect(found?.createdAt.isUtc, isTrue);
  });

  test('find fails with NotFoundFailure for an unknown id', () async {
    final result = await repo.find('missing');
    expect((result as Err<Client>).failure, isA<NotFoundFailure>());
  });

  test('lists A-Z ignoring case', () async {
    await repo.save(client('1', 'zed'));
    await repo.save(client('2', 'Alpha'));
    await repo.save(client('3', 'beta'));
    expect(await names(), ['Alpha', 'beta', 'zed']);
  });

  test('search matches name, email and phone in either digit set', () async {
    await repo.save(client('1', 'Rahman Traders', phone: '01712345678'));
    await repo.save(client('2', 'Karim', email: 'karim@shop.com'));
    await repo.save(client('3', 'করিম স্টোর'));

    expect(await names(query: 'rahman'), ['Rahman Traders']);
    expect(await names(query: 'SHOP.com'), ['Karim']);
    expect(await names(query: '১২৩৪'), ['Rahman Traders']);
    expect(await names(query: '1234'), ['Rahman Traders']);
    expect(await names(query: 'করিম'), ['করিম স্টোর']);
    expect(await names(query: '  '), hasLength(3));
  });

  test('search treats % and _ as plain text', () async {
    await repo.save(client('1', '100% Cotton'));
    await repo.save(client('2', '100 Cotton'));
    await repo.save(client('3', 'a_b'));
    await repo.save(client('4', 'axb'));
    expect(await names(query: '0%'), ['100% Cotton']);
    expect(await names(query: 'a_b'), ['a_b']);
  });

  test('save updates in place and delete removes', () async {
    await repo.save(client('1', 'Old'));
    await repo.save(client('1', 'New'));
    expect(await names(), ['New']);

    expect((await repo.delete('1')).isOk, isTrue);
    expect(await names(), isEmpty);
  });

  test('the list stream updates after changes', () async {
    final emitted = repo.watchAll().map((l) => l.length);
    final expectation = expectLater(emitted, emitsInOrder([0, 1]));
    await Future<void>.delayed(Duration.zero);
    await repo.save(client('1', 'Live'));
    await expectation;
  });
}
