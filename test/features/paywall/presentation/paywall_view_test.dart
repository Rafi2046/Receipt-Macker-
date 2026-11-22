import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/purchases/pro_plan.dart';
import 'package:receipt_maker/core/services/purchases/purchase_providers.dart';
import 'package:receipt_maker/core/services/purchases/purchase_repository.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/features/paywall/presentation/views/paywall_view.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/pump_app.dart';

class MockPurchaseRepository extends Mock implements PurchaseRepository {}

void main() {
  late MockPurchaseRepository mockRepo;
  late FakeAppPreferences fakePrefs;

  setUp(() {
    mockRepo = MockPurchaseRepository();
    fakePrefs = FakeAppPreferences();
  });

  final testPlans = [
    const ProPlan(
      id: AppConstants.proMonthlyId,
      period: ProPeriod.monthly,
      price: '\$4.99',
    ),
    const ProPlan(
      id: AppConstants.proYearlyId,
      period: ProPeriod.yearly,
      price: '\$39.99',
      trialDays: 7,
    ),
  ];

  testWidgets(
    'renders plans with prices, comparison table and restore button',
    (tester) async {
      when(() => mockRepo.loadPlans()).thenAnswer((_) async => Ok(testPlans));

      await tester.pumpApp(
        const PaywallView(),
        surface: const Size(800, 1400),
        overrides: [
          appPreferencesProvider.overrideWithValue(fakePrefs),
          purchaseRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      expect(find.text('Upgrade to'), findsOneWidget);
      expect(find.text('PRO'), findsWidgets);
      expect(find.text('\$4.99'), findsOneWidget);
      expect(find.text('\$39.99'), findsOneWidget);
      expect(find.text('Restore purchases'), findsOneWidget);
      expect(find.text('Terms'), findsOneWidget);
      expect(find.text('Privacy policy'), findsOneWidget);
      expect(find.text('Invoices and receipts'), findsOneWidget);
      expect(find.text('Invoice designs'), findsOneWidget);
    },
  );

  testWidgets('yearly is preselected; Continue buys the chosen plan', (
    tester,
  ) async {
    when(() => mockRepo.loadPlans()).thenAnswer((_) async => Ok(testPlans));
    when(() => mockRepo.buy(any())).thenAnswer((_) async => const Ok(false));

    await tester.pumpApp(
      const PaywallView(),
      surface: const Size(400, 1800),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        purchaseRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    // The yearly plan has a 7-day trial, so the button says so.
    expect(find.text('Start 7-day free trial'), findsOneWidget);

    await tester.tap(find.text('Monthly'));
    await tester.pumpAndSettle();
    expect(find.text('Continue'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    verify(() => mockRepo.buy(AppConstants.proMonthlyId)).called(1);
  });

  testWidgets('fits at 2x font in Bangla', (tester) async {
    when(() => mockRepo.loadPlans()).thenAnswer((_) async => Ok(testPlans));
    await tester.pumpApp(
      const PaywallView(),
      language: 'bn',
      textScale: 2,
      surface: const Size(360, 740),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        purchaseRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping restore purchases shows success message when restored', (
    tester,
  ) async {
    when(() => mockRepo.loadPlans()).thenAnswer((_) async => Ok(testPlans));
    when(() => mockRepo.restore()).thenAnswer((_) async => const Ok(true));

    await tester.pumpApp(
      const PaywallView(),
      surface: const Size(800, 1400),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        purchaseRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    await tester.tap(find.text('Restore purchases'));
    await tester.pumpAndSettle();

    expect(find.text('Pro is restored on this phone.'), findsOneWidget);
  });

  testWidgets('shows notice when nothing to restore', (tester) async {
    when(() => mockRepo.loadPlans()).thenAnswer((_) async => Ok(testPlans));
    when(() => mockRepo.restore()).thenAnswer((_) async => const Ok(false));

    await tester.pumpApp(
      const PaywallView(),
      surface: const Size(800, 1400),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        purchaseRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    await tester.tap(find.text('Restore purchases'));
    await tester.pumpAndSettle();

    expect(
      find.text('No Pro purchase was found for this Google account.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'shows price unavailable and retry button when plans fail to load',
    (tester) async {
      when(() => mockRepo.loadPlans())
          .thenAnswer((_) async => const Err(UnexpectedFailure()));

      await tester.pumpApp(
        const PaywallView(),
        surface: const Size(800, 1400),
        overrides: [
          appPreferencesProvider.overrideWithValue(fakePrefs),
          purchaseRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );

      expect(
        find.text('Prices come from Google Play. Connect and try again.'),
        findsOneWidget,
      );
      expect(find.text('Retry'), findsOneWidget);
    },
  );
}
