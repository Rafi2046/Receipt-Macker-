import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/provider_retry.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';
import 'package:receipt_maker/features/items/domain/models/item_field.dart';
import 'package:receipt_maker/features/items/presentation/view_models/item_editor_state.dart';
import 'package:receipt_maker/features/items/presentation/view_models/item_editor_view_model.dart';
import 'package:receipt_maker/features/items/providers.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';

void main() {
  setUpAll(registerRepositoryFallbacks);

  late MockItemRepository repo;
  late ProviderContainer container;

  Future<void> open(String? id, {String? defaultCurrency}) async {
    container = ProviderContainer(
      overrides: [
        itemRepositoryProvider.overrideWithValue(repo),
        appPreferencesProvider.overrideWithValue(
          FakeAppPreferences(defaultCurrency: defaultCurrency),
        ),
      ],
      retry: appProviderRetry,
    )..listen(itemEditorViewModelProvider(id), (_, _) {});
    try {
      await container.read(itemEditorViewModelProvider(id).future);
    } on Failure {
      // Error-state tests inspect the provider afterwards.
    }
  }

  ItemEditorViewModel vm(String? id) =>
      container.read(itemEditorViewModelProvider(id).notifier);
  ItemEditorState form(String? id) =>
      container.read(itemEditorViewModelProvider(id)).requireValue;

  setUp(() {
    repo = MockItemRepository();
    when(() => repo.save(any()))
        .thenAnswer((i) async => Ok(i.positionalArguments.first as Item));
    when(() => repo.delete(any())).thenAnswer((_) async => const Ok(null));
  });
  tearDown(() => container.dispose());

  test('a new item uses the default currency from settings', () async {
    await open(null, defaultCurrency: 'USD');
    expect(form(null).draft.currencyCode, 'USD');
    expect(form(null).hasPrice, isFalse);
    expect(form(null).hasUnsavedChanges, isFalse);
  });

  test('falls back to BDT before a currency is chosen', () async {
    await open(null);
    expect(form(null).draft.currencyCode, 'BDT');
  });

  test('name and price are required before saving', () async {
    await open(null);
    expect(await vm(null).save(), isNull);
    expect(form(null).errorFor(ItemField.name), ValidationError.required);
    expect(form(null).errorFor(ItemField.unitPrice), ValidationError.required);
    verifyNever(() => repo.save(any()));
  });

  test('saves price in minor units with currency, unit and tax', () async {
    await open(null);
    vm(null)
      ..setName('Logo design')
      ..setUnit('pcs')
      ..setCurrency('JPY')
      ..setUnitPrice(1500)
      ..setDefaultTax(750);
    final saved = await vm(null).save();
    expect(saved?.unitPriceMinor, 1500);
    expect(saved?.currencyCode, 'JPY');
    expect(saved?.unit, 'pcs');
    expect(saved?.defaultTaxBasisPoints, 750);
    expect(form(null).hasUnsavedChanges, isFalse);
  });

  test('a zero price is a valid price', () async {
    await open(null);
    vm(null)
      ..setName('Free consultation')
      ..setUnitPrice(0);
    expect(await vm(null).save(), isNotNull);
  });

  test('tax over 100% blocks saving', () async {
    await open(null);
    vm(null)
      ..setName('Pen')
      ..setUnitPrice(1000)
      ..setDefaultTax(10001);
    expect(await vm(null).save(), isNull);
    expect(
      form(null).errorFor(ItemField.defaultTax),
      ValidationError.percentTooHigh,
    );
  });

  test('typing then clearing a new price leaves no unsaved change', () async {
    await open(null);
    vm(null).setUnitPrice(0);
    expect(form(null).hasUnsavedChanges, isTrue);
    vm(null).setUnitPrice(null);
    expect(form(null).hasUnsavedChanges, isFalse);
  });

  test('clearing the price of an existing item is an unsaved change', () async {
    when(() => repo.find('i1')).thenAnswer((_) async => Ok(testItem(price: 0)));
    await open('i1');
    expect(form('i1').hasUnsavedChanges, isFalse);
    vm('i1').setUnitPrice(null);
    expect(form('i1').hasUnsavedChanges, isTrue);
  });

  test('loads an existing item and deletes it by id', () async {
    when(() => repo.find('i1')).thenAnswer((_) async => Ok(testItem()));
    await open('i1');
    expect(form('i1').draft.name, 'Logo design');
    expect(form('i1').hasPrice, isTrue);
    expect(await vm('i1').delete(), isTrue);
    verify(() => repo.delete('i1')).called(1);
  });

  test('a failed delete reports the failure', () async {
    when(() => repo.find('i1')).thenAnswer((_) async => Ok(testItem()));
    when(() => repo.delete('i1'))
        .thenAnswer((_) async => const Err(DatabaseFailure()));
    await open('i1');
    expect(await vm('i1').delete(), isFalse);
    expect(form('i1').failure, isA<DatabaseFailure>());
    expect(form('i1').isDeleting, isFalse);
  });

  test('an unknown id ends in an error state', () async {
    when(() => repo.find('gone'))
        .thenAnswer((_) async => const Err(NotFoundFailure()));
    await open('gone');
    final value = container.read(itemEditorViewModelProvider('gone'));
    expect(value.error, isA<NotFoundFailure>());
  });
}
