import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/services/url_launch_service.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_numbering.dart';
import 'package:receipt_maker/features/invoices/providers.dart';
import 'package:receipt_maker/features/settings/presentation/views/settings_view.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late MockInvoiceRepository mockInvoiceRepo;
  late FakeAppPreferences fakePrefs;

  setUp(() {
    mockInvoiceRepo = MockInvoiceRepository();
    fakePrefs = FakeAppPreferences();

    when(() => mockInvoiceRepo.getNumbering()).thenAnswer(
      (_) async => const Ok(InvoiceNumbering(prefix: 'INV-', nextSequence: 5)),
    );
    when(() => mockInvoiceRepo.getHighestSequence('INV-'))
        .thenAnswer((_) async => const Ok(4));
  });

  testWidgets(
    'renders About & Legal section with Privacy Policy and Terms tiles in English',
    (tester) async {
      String? launchedUrl;
      UrlLaunchService.urlLauncherOverride = (url) async {
        launchedUrl = url;
        return true;
      };
      addTearDown(() => UrlLaunchService.urlLauncherOverride = null);

      await tester.pumpApp(
        const SettingsView(),
        surface: const Size(800, 1600),
        overrides: [
          appPreferencesProvider.overrideWithValue(fakePrefs),
          invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
        ],
      );

      expect(find.text('About & Legal'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
      expect(find.text('Terms of Service'), findsOneWidget);

      // Tap Privacy Policy
      await tester.tap(find.text('Privacy Policy'));
      await tester.pumpAndSettle();
      expect(launchedUrl, AppConstants.privacyPolicyUrl);

      // Tap Terms of Service
      await tester.tap(find.text('Terms of Service'));
      await tester.pumpAndSettle();
      expect(launchedUrl, AppConstants.termsOfServiceUrl);
    },
  );

  testWidgets('renders About & Legal section in Bangla', (tester) async {
    await tester.pumpApp(
      const SettingsView(),
      language: 'bn',
      surface: const Size(800, 1600),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
      ],
    );

    expect(find.text('আইনি ও তথ্যাবলী'), findsOneWidget);
    expect(find.text('গোপনীয়তা নীতি'), findsOneWidget);
    expect(find.text('ব্যবহারের শর্তাবলী'), findsOneWidget);
  });
}
