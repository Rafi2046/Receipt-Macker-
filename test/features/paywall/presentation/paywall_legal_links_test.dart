import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/purchases/pro_plan.dart';
import 'package:receipt_maker/core/services/purchases/purchase_providers.dart';
import 'package:receipt_maker/core/services/purchases/purchase_repository.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/services/url_launch_service.dart';
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

  testWidgets('paywall legal buttons launch external privacy and terms URLs', (
    tester,
  ) async {
    final launchedUrls = <String>[];
    UrlLaunchService.urlLauncherOverride = (url) async {
      launchedUrls.add(url);
      return true;
    };
    addTearDown(() => UrlLaunchService.urlLauncherOverride = null);

    when(() => mockRepo.loadPlans()).thenAnswer(
      (_) async => const Ok([
        ProPlan(
          id: AppConstants.proMonthlyId,
          period: ProPeriod.monthly,
          price: '\$4.99',
        ),
      ]),
    );

    await tester.pumpApp(
      const PaywallView(),
      surface: const Size(800, 1400),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        purchaseRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    // Tap Privacy Policy link at bottom of paywall
    await tester.tap(find.text('Privacy policy'));
    await tester.pumpAndSettle();
    expect(launchedUrls, contains(AppConstants.privacyPolicyUrl));

    // Tap Terms link at bottom of paywall
    await tester.tap(find.text('Terms'));
    await tester.pumpAndSettle();
    expect(launchedUrls, contains(AppConstants.termsOfServiceUrl));
  });
}
