import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/provider_retry.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/clients/domain/models/client_field.dart';
import 'package:receipt_maker/features/clients/presentation/view_models/client_editor_state.dart';
import 'package:receipt_maker/features/clients/presentation/view_models/client_editor_view_model.dart';
import 'package:receipt_maker/features/clients/providers.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';

void main() {
  setUpAll(registerRepositoryFallbacks);

  late MockClientRepository repo;
  late ProviderContainer container;

  Future<void> open(String? id) async {
    container = ProviderContainer(
      overrides: [
        clientRepositoryProvider.overrideWithValue(repo),
        appPreferencesProvider.overrideWithValue(FakeAppPreferences()),
      ],
      retry: appProviderRetry,
    )..listen(clientEditorViewModelProvider(id), (_, _) {});
    try {
      await container.read(clientEditorViewModelProvider(id).future);
    } on Failure {
      // Error-state tests inspect the provider afterwards.
    }
  }

  ClientEditorViewModel vm(String? id) =>
      container.read(clientEditorViewModelProvider(id).notifier);
  ClientEditorState form(String? id) =>
      container.read(clientEditorViewModelProvider(id)).requireValue;

  setUp(() {
    repo = MockClientRepository();
    when(() => repo.save(any()))
        .thenAnswer((i) async => Ok(i.positionalArguments.first as Client));
    when(() => repo.delete(any())).thenAnswer((_) async => const Ok(null));
    when(() => repo.watchAll(query: any(named: 'query')))
        .thenAnswer((_) => Stream.value(const []));
  });
  tearDown(() => container.dispose());

  group('new client', () {
    setUp(() => open(null));

    test('starts blank, unchanged, with errors hidden', () {
      expect(form(null).isNew, isTrue);
      expect(form(null).hasUnsavedChanges, isFalse);
      expect(form(null).errorFor(ClientField.name), isNull);
    });

    test('save without a name shows the error and does not save', () async {
      expect(await vm(null).save(), isNull);
      expect(form(null).errorFor(ClientField.name), ValidationError.required);
      verifyNever(() => repo.save(any()));
    });

    test('save stores the draft and clears unsaved changes', () async {
      vm(null).updateField(ClientField.name, 'করিম স্টোর');
      vm(null).updateField(ClientField.phone, '01712345678');
      expect(form(null).hasUnsavedChanges, isTrue);

      final saved = await vm(null).save();
      expect(saved?.name, 'করিম স্টোর');
      expect(saved?.phone, '01712345678');
      expect(form(null).hasUnsavedChanges, isFalse);
      expect(form(null).isNew, isFalse);
      verify(() => repo.save(any())).called(1);
    });

    test('a failed save keeps the draft and reports the failure', () async {
      when(() => repo.save(any()))
          .thenAnswer((_) async => const Err(DatabaseFailure()));
      vm(null).updateField(ClientField.name, 'A');

      expect(await vm(null).save(), isNull);
      expect(form(null).failure, isA<DatabaseFailure>());
      expect(form(null).isSaving, isFalse);
      expect(form(null).hasUnsavedChanges, isTrue);

      vm(null).clearFailure();
      expect(form(null).failure, isNull);
    });

    test('a new client cannot be deleted', () async {
      expect(await vm(null).delete(), isFalse);
      verifyNever(() => repo.delete(any()));
    });
  });

  group('existing client', () {
    test('loads the client and deletes it by id', () async {
      when(() => repo.find('c1')).thenAnswer((_) async => Ok(testClient()));
      await open('c1');
      expect(form('c1').draft.name, 'Rahman Traders');
      expect(form('c1').isNew, isFalse);

      expect(await vm('c1').delete(), isTrue);
      verify(() => repo.delete('c1')).called(1);
    });

    test('an unknown id ends in an error state', () async {
      when(() => repo.find('gone'))
          .thenAnswer((_) async => const Err(NotFoundFailure()));
      await open('gone');
      final value = container.read(clientEditorViewModelProvider('gone'));
      expect(value.error, isA<NotFoundFailure>());
    });

    test('editing back to the original is not an unsaved change', () async {
      when(() => repo.find('c1')).thenAnswer((_) async => Ok(testClient()));
      await open('c1');
      vm('c1').updateField(ClientField.name, 'Other');
      expect(form('c1').hasUnsavedChanges, isTrue);
      vm('c1').updateField(ClientField.name, 'Rahman Traders');
      expect(form('c1').hasUnsavedChanges, isFalse);
    });
  });
}
