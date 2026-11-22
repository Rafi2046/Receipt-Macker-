import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/ads/consent_service.dart';
import 'package:receipt_maker/core/services/purchases/purchase_providers.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_numbering.dart';
import 'package:receipt_maker/features/invoices/providers.dart';
import 'package:receipt_maker/features/settings/presentation/views/settings_view.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/pump_app.dart';

class FakeProStatus extends ProStatus {
  FakeProStatus(this._isPro);
  final bool _isPro;

  @override
  bool build() => _isPro;
}

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

  testWidgets('displays privacy consent card when required for free user', (
    tester,
  ) async {
    final fakeConsent = FakeConsentService(required: true);

    await tester.pumpApp(
      const SettingsView(),
      surface: const Size(800, 1400),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
        proStatusProvider.overrideWith(() => FakeProStatus(false)),
        consentServiceProvider.overrideWithValue(fakeConsent),
      ],
    );

    expect(find.text('Ad Privacy Settings'), findsOneWidget);
    expect(
      find.text('Manage your advertising consent preferences'),
      findsOneWidget,
    );

    // Tapping the card opens the privacy options form
    await tester.tap(find.text('Manage your advertising consent preferences'));
    await tester.pumpAndSettle();

    expect(fakeConsent.formShown, isTrue);
  });

  testWidgets('hides privacy consent card when user is Pro', (tester) async {
    final fakeConsent = FakeConsentService(required: true);

    await tester.pumpApp(
      const SettingsView(),
      surface: const Size(800, 1400),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
        proStatusProvider.overrideWith(() => FakeProStatus(true)),
        consentServiceProvider.overrideWithValue(fakeConsent),
      ],
    );

    expect(find.text('Ad Privacy Settings'), findsNothing);
  });
}
