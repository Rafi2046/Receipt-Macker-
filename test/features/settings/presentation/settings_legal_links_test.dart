import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/router/route_names.dart';
import 'package:receipt_maker/app/theme/app_theme.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/services/url_launch_service.dart';
import 'package:receipt_maker/features/business_profile/providers.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_numbering.dart';
import 'package:receipt_maker/features/invoices/providers.dart';
import 'package:receipt_maker/features/settings/presentation/views/privacy_policy_view.dart';
import 'package:receipt_maker/features/settings/presentation/views/settings_view.dart';
import 'package:receipt_maker/features/settings/presentation/views/support_view.dart';
import 'package:receipt_maker/features/settings/presentation/views/terms_view.dart';
import 'package:receipt_maker/l10n/gen/app_localizations.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late MockInvoiceRepository repo;

  setUp(() {
    repo = MockInvoiceRepository();
    when(() => repo.getNumbering()).thenAnswer(
      (_) async => const Ok(InvoiceNumbering(prefix: 'INV-', nextSequence: 5)),
    );
    when(() => repo.getHighestSequence(any()))
        .thenAnswer((_) async => const Ok(4));
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    tester.view.physicalSize =
        const Size(400, 2400) * tester.view.devicePixelRatio;
    addTearDown(tester.view.resetPhysicalSize);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const SettingsView()),
        GoRoute(
          name: RouteNames.privacy,
          path: RouteNames.privacyPath,
          builder: (_, _) => const PrivacyPolicyView(),
        ),
        GoRoute(
          name: RouteNames.terms,
          path: RouteNames.termsPath,
          builder: (_, _) => const TermsView(),
        ),
        GoRoute(
          name: RouteNames.support,
          path: RouteNames.supportPath,
          builder: (_, _) => const SupportView(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPreferencesProvider.overrideWithValue(FakeAppPreferences()),
          invoiceRepositoryProvider.overrideWithValue(repo),
          currentBusinessProfileProvider.overrideWith(
            (ref) => Stream.value(null),
          ),
        ],
        child: MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('legal rows open the in-app pages', (tester) async {
    await pumpSettings(tester);
    expect(find.text('ABOUT & LEGAL'), findsOneWidget);

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();
    expect(find.text('1. Your data stays on your phone'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Terms of Service'));
    await tester.pumpAndSettle();
    expect(find.text('2. QuickBill Pro'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Help & support'));
    await tester.pumpAndSettle();
    expect(find.text('Common questions'.toUpperCase()), findsOneWidget);
  });

  testWidgets('privacy page shows every point and the support email', (
    tester,
  ) async {
    await tester.pumpApp(
      const PrivacyPolicyView(),
      surface: const Size(400, 4000),
    );
    const titles = [
      'Your data stays on your phone',
      'Backups are your files',
      'Ads',
      'Purchases',
      'Usage and crash reports',
      'Photos and contacts',
      'Deleting your data',
      'Changes to this policy',
    ];
    for (var i = 0; i < titles.length; i++) {
      final heading = '${i + 1}. ${titles[i]}';
      expect(find.text(heading), findsOneWidget, reason: heading);
    }
    expect(find.text(AppConstants.supportEmail), findsOneWidget);
  });

  testWidgets('support emails us with a subject and copies the address', (
    tester,
  ) async {
    String? launched;
    UrlLaunchService.urlLauncherOverride = (url) async {
      launched = url;
      return true;
    };
    addTearDown(() => UrlLaunchService.urlLauncherOverride = null);
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );

    await tester.pumpApp(const SupportView(), surface: const Size(400, 3000));
    await tester.tap(find.text('Send an email'));
    await tester.pumpAndSettle();
    expect(
      launched,
      'mailto:${AppConstants.supportEmail}?subject=QuickBill%20support',
    );

    await tester.tap(find.text('Copy email'));
    await tester.pumpAndSettle();
    expect(copied, AppConstants.supportEmail);
    expect(find.text('Email address copied'), findsOneWidget);

    await tester.tap(find.text('How do I cancel Pro?'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Payments & subscriptions'), findsOneWidget);
  });

  testWidgets('legal and support pages fit at 2x in Bangla', (tester) async {
    for (final page in const [
      PrivacyPolicyView(),
      TermsView(),
      SupportView(),
    ]) {
      await tester.pumpApp(
        page,
        language: 'bn',
        textScale: 2,
        surface: const Size(360, 740),
      );
      expect(tester.takeException(), isNull);
    }
  });
}
