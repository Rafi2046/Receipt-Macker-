import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/database/app_database.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/features/items/data/repositories/item_repository_impl.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';

void main() {
  late AppDatabase db;
  late ItemRepositoryImpl repo;
  final t = DateTime.utc(2026, 10, 20, 8);

  Item item(
    String id,
    String name, {
    String description = '',
    String unit = '',
    int price = 0,
    String currency = 'BDT',
    int? tax,
  }) => Item(
    id: id,
    name: name,
    description: description,
    unit: unit,
    unitPriceMinor: price,
    currencyCode: currency,
    defaultTaxBasisPoints: tax,
    createdAt: t,
    updatedAt: t,
  );

  Future<List<String>> names({String query = ''}) async =>
      (await repo.watchAll(query: query).first).map((i) => i.name).toList();

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repo = ItemRepositoryImpl(db.itemDao);
  });
  tearDown(() => db.close());

  test('round-trips money as integers with currency and tax', () async {
    await repo.save(
      item('a', ' Logo design ', price: 1500000, currency: 'JPY', tax: 750),
    );
    final found = (await repo.find('a')).valueOrNull;
    expect(found?.name, 'Logo design');
    expect(found?.unitPriceMinor, 1500000);
    expect(found?.currencyCode, 'JPY');
    expect(found?.defaultTaxBasisPoints, 750);
  });

  test('no default tax stays null', () async {
    await repo.save(item('a', 'Pen'));
    expect((await repo.find('a')).valueOrNull?.defaultTaxBasisPoints, isNull);
  });

  test('find fails with NotFoundFailure for an unknown id', () async {
    final result = await repo.find('missing');
    expect((result as Err<Item>).failure, isA<NotFoundFailure>());
  });

  test('lists A-Z and searches name, description and unit', () async {
    await repo.save(item('1', 'website', description: 'Landing page'));
    await repo.save(item('2', 'Chal', unit: 'কেজি'));
    await repo.save(item('3', 'ডিজাইন'));

    expect(await names(), ['Chal', 'website', 'ডিজাইন']);
    expect(await names(query: 'LANDING'), ['website']);
    expect(await names(query: 'কেজি'), ['Chal']);
    expect(await names(query: 'ডিজা'), ['ডিজাইন']);
    expect(await names(query: 'zzz'), isEmpty);
  });

  test('delete removes the item', () async {
    await repo.save(item('1', 'Pen'));
    expect((await repo.delete('1')).isOk, isTrue);
    expect(await names(), isEmpty);
  });
}
