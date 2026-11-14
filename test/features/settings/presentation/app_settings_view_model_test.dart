import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_numbering.dart';
import 'package:receipt_maker/features/invoices/providers.dart';
import 'package:receipt_maker/features/settings/domain/models/app_language.dart';
import 'package:receipt_maker/features/settings/domain/models/app_theme_preference.dart';
import 'package:receipt_maker/features/settings/presentation/view_models/app_settings_view_model.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';

void main() {
  late FakeAppPreferences fakePrefs;
  late MockInvoiceRepository mockInvoiceRepo;
  late ProviderContainer container;

  setUp(() {
    fakePrefs = FakeAppPreferences();
    mockInvoiceRepo = MockInvoiceRepository();
    container = ProviderContainer(
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('initial state reads from preferences', () {
    final state = container.read(appSettingsViewModelProvider);
    expect(state.language, AppLanguage.en);
    expect(state.theme, AppThemePreference.system);
    expect(state.defaultCurrency, 'BDT');
    expect(state.defaultDueDays, 7);
    expect(state.defaultTaxRateBasisPoints, isNull);
    expect(state.defaultTaxInclusive, isFalse);
  });

  test('setLanguage updates state and preferences', () async {
    final vm = container.read(appSettingsViewModelProvider.notifier);
    await vm.setLanguage(AppLanguage.bn);

    expect(
      container.read(appSettingsViewModelProvider).language,
      AppLanguage.bn,
    );
    expect(fakePrefs.languageCode, 'bn');
  });

  test('setTheme updates state and preferences', () async {
    final vm = container.read(appSettingsViewModelProvider.notifier);
    await vm.setTheme(AppThemePreference.dark);

    expect(
      container.read(appSettingsViewModelProvider).theme,
      AppThemePreference.dark,
    );
    expect(fakePrefs.themeName, 'dark');
  });

  test('setDefaultCurrency updates state and preferences', () async {
    final vm = container.read(appSettingsViewModelProvider.notifier);
    await vm.setDefaultCurrency('USD');

    expect(container.read(appSettingsViewModelProvider).defaultCurrency, 'USD');
    expect(fakePrefs.defaultCurrency, 'USD');
  });

  test('setDefaultDueDays updates state and preferences', () async {
    final vm = container.read(appSettingsViewModelProvider.notifier);
    await vm.setDefaultDueDays(15);

    expect(container.read(appSettingsViewModelProvider).defaultDueDays, 15);
    expect(fakePrefs.defaultDueDays, 15);
  });

  test('setDefaultTaxRateBasisPoints updates state and preferences', () async {
    final vm = container.read(appSettingsViewModelProvider.notifier);
    await vm.setDefaultTaxRateBasisPoints(500);

    expect(
      container.read(appSettingsViewModelProvider).defaultTaxRateBasisPoints,
      500,
    );
    expect(fakePrefs.defaultTaxRateBasisPoints, 500);
  });

  test('setDefaultTaxInclusive updates state and preferences', () async {
    final vm = container.read(appSettingsViewModelProvider.notifier);
    await vm.setDefaultTaxInclusive(value: true);

    expect(
      container.read(appSettingsViewModelProvider).defaultTaxInclusive,
      isTrue,
    );
    expect(fakePrefs.defaultTaxInclusive, isTrue);
  });

  test('loadNumbering reads from invoice repository', () async {
    when(() => mockInvoiceRepo.getNumbering()).thenAnswer(
      (_) async => const Ok(InvoiceNumbering(prefix: 'INV-', nextSequence: 8)),
    );
    when(() => mockInvoiceRepo.getHighestSequence('INV-'))
        .thenAnswer((_) async => const Ok(7));

    final vm = container.read(appSettingsViewModelProvider.notifier);
    await vm.loadNumbering();

    final state = container.read(appSettingsViewModelProvider);
    expect(state.invoicePrefix, 'INV-');
    expect(state.nextInvoiceSequence, 8);
    expect(state.highestInvoiceSequence, 7);
  });

  test('updateNumbering rejects empty prefix', () async {
    final vm = container.read(appSettingsViewModelProvider.notifier);
    final ok = await vm.updateNumbering(prefix: '  ', nextSequence: 5);

    expect(ok, isFalse);
    expect(
      container.read(appSettingsViewModelProvider).failure,
      isA<ValidationFailure>(),
    );
  });

  test('updateNumbering rejects sequence <= highest used sequence', () async {
    when(() => mockInvoiceRepo.getHighestSequence('INV-'))
        .thenAnswer((_) async => const Ok(10));

    final vm = container.read(appSettingsViewModelProvider.notifier);
    final ok = await vm.updateNumbering(prefix: 'INV-', nextSequence: 10);

    expect(ok, isFalse);
    expect(
      container.read(appSettingsViewModelProvider).failure,
      isA<ValidationFailure>(),
    );
  });

  test('updateNumbering saves when valid', () async {
    when(() => mockInvoiceRepo.getHighestSequence('INV-'))
        .thenAnswer((_) async => const Ok(10));
    when(
      () => mockInvoiceRepo.updateNumbering(prefix: 'INV-', nextSequence: 15),
    ).thenAnswer((_) async => const Ok(null));

    final vm = container.read(appSettingsViewModelProvider.notifier);
    final ok = await vm.updateNumbering(prefix: 'INV-', nextSequence: 15);

    expect(ok, isTrue);
    final state = container.read(appSettingsViewModelProvider);
    expect(state.numberingSaved, isTrue);
    expect(state.nextInvoiceSequence, 15);
    expect(state.failure, isNull);
  });
}
