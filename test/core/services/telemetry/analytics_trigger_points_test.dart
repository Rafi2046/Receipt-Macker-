import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/provider_retry.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/clock.dart';
import 'package:receipt_maker/core/services/purchases/purchase_providers.dart';
import 'package:receipt_maker/core/services/purchases/purchase_repository.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/services/telemetry/analytics_service.dart';
import 'package:receipt_maker/features/backup/domain/repositories/backup_repository.dart';
import 'package:receipt_maker/features/backup/presentation/view_models/backup_view_model.dart';
import 'package:receipt_maker/features/backup/providers.dart';
import 'package:receipt_maker/features/business_profile/business_profile.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/presentation/view_models/invoice_editor_view_model.dart';
import 'package:receipt_maker/features/invoices/providers.dart';
import 'package:receipt_maker/features/paywall/presentation/view_models/paywall_view_model.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';

class MockPurchaseRepository extends Mock implements PurchaseRepository {}

class MockBackupRepository extends Mock implements BackupRepository {}

void main() {
  setUpAll(() {
    registerRepositoryFallbacks();
    registerFallbackValue(File('dummy'));
  });

  group('Analytics trigger points', () {
    test('invoice_created event is recorded on saving a new invoice', () async {
      final repo = MockInvoiceRepository();
      final profiles = MockBusinessProfileRepository();
      final fakeAnalytics = FakeAnalyticsService();
      final fakePrefs = FakeAppPreferences(defaultCurrency: 'BDT');
      final now = DateTime(2026, 10, 20, 15);

      when(repo.suggestNumber).thenAnswer((_) async => const Ok('INV-0001'));
      when(profiles.load).thenAnswer((_) async => const Ok(null));
      when(() => repo.save(any()))
          .thenAnswer((i) async => Ok(i.positionalArguments.first as Invoice));

      final provider = invoiceEditorViewModelProvider(null, null);
      final container = ProviderContainer(
        overrides: [
          invoiceRepositoryProvider.overrideWithValue(repo),
          businessProfileRepositoryProvider.overrideWithValue(profiles),
          appPreferencesProvider.overrideWithValue(fakePrefs),
          analyticsServiceProvider.overrideWithValue(fakeAnalytics),
          clockProvider.overrideWithValue(() => now),
        ],
        retry: appProviderRetry,
      )..listen(provider, (_, _) {});

      await container.read(provider.future);

      // Add one item so invoice is valid to save
      final vm = container.read(provider.notifier);
      vm.addItem(testItem());

      final saved = await vm.save();
      expect(saved, isNotNull);

      // Verify invoice_created was logged
      expect(fakeAnalytics.recordedEvents, hasLength(1));
      expect(fakeAnalytics.recordedEvents.first.$1, 'invoice_created');
      expect(fakeAnalytics.recordedEvents.first.$2, {
        'template_name': 'classic',
        'item_count': 1,
      });

      container.dispose();
    });

    test('backup_exported event is recorded on creating a backup', () async {
      final backupRepo = MockBackupRepository();
      final fakeAnalytics = FakeAnalyticsService();

      when(backupRepo.getLastBackupDate).thenReturn(null);
      when(backupRepo.createBackup).thenAnswer((_) async => File('dummy.zip'));
      when(() => backupRepo.shareBackup(any())).thenAnswer((_) async => true);

      final container = ProviderContainer(
        overrides: [
          backupRepositoryProvider.overrideWithValue(backupRepo),
          analyticsServiceProvider.overrideWithValue(fakeAnalytics),
        ],
      );

      final vm = container.read(backupViewModelProvider.notifier);
      await vm.createBackup();

      expect(fakeAnalytics.recordedEvents, hasLength(1));
      expect(fakeAnalytics.recordedEvents.first.$1, 'backup_exported');

      container.dispose();
    });

    test(
      'pro_purchased event is recorded on successful Pro purchase',
      () async {
        final purchaseRepo = MockPurchaseRepository();
        final fakeAnalytics = FakeAnalyticsService();
        final fakePrefs = FakeAppPreferences();

        when(purchaseRepo.loadPlans).thenAnswer((_) async => const Ok([]));
        when(() => purchaseRepo.buy('quickbill_pro_yearly'))
            .thenAnswer((_) async => const Ok(true));

        final container = ProviderContainer(
          overrides: [
            purchaseRepositoryProvider.overrideWithValue(purchaseRepo),
            appPreferencesProvider.overrideWithValue(fakePrefs),
            analyticsServiceProvider.overrideWithValue(fakeAnalytics),
          ],
        );

        final vm = container.read(paywallViewModelProvider.notifier);
        final success = await vm.buy('quickbill_pro_yearly');
        expect(success, isTrue);

        expect(fakeAnalytics.recordedEvents, hasLength(1));
        expect(fakeAnalytics.recordedEvents.first.$1, 'pro_purchased');
        expect(fakeAnalytics.recordedEvents.first.$2, {
          'product_id': 'quickbill_pro_yearly',
        });

        container.dispose();
      },
    );
  });
}
