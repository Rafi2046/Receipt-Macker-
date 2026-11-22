import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
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
    when(
      () => mockInvoiceRepo.getHighestSequence(any()),
    ).thenAnswer((_) async => const Ok(4));
    when(
      () => mockInvoiceRepo.updateNumbering(
        prefix: any(named: 'prefix'),
        nextSequence: any(named: 'nextSequence'),
      ),
    ).thenAnswer((_) async => const Ok(null));
  });

  Future<void> pump(
    WidgetTester tester, {
    String language = 'en',
    double textScale = 1,
  }) => tester.pumpApp(
    const SettingsView(),
    language: language,
    textScale: textScale,
    surface: const Size(400, 1400),
    overrides: [
      appPreferencesProvider.overrideWithValue(fakePrefs),
      invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
    ],
  );

  testWidgets('shows grouped rows with current values', (tester) async {
    await pump(tester);
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('APPEARANCE & LANGUAGE'), findsOneWidget);
    expect(find.text('App language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('DEFAULT INVOICE TERMS'), findsOneWidget);
    expect(find.text('Next: INV-0005'), findsOneWidget);
  });

  testWidgets('language row opens a sheet and saves the pick', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('App language'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('বাংলা'));
    await tester.pumpAndSettle();
    expect(fakePrefs.languageCode, 'bn');
  });

  testWidgets('numbering sheet rejects a used number and saves a new one', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.text('Invoice numbers'));
    await tester.pumpAndSettle();
    final next = find.widgetWithText(TextField, '5');
    await tester.enterText(next, '3');
    await tester.tap(find.text('Save numbering'));
    await tester.pumpAndSettle();
    expect(
      find.text('Next number must be higher than existing invoices'),
      findsOneWidget,
    );

    await tester.enterText(find.widgetWithText(TextField, '3'), '20');
    await tester.tap(find.text('Save numbering'));
    await tester.pumpAndSettle();
    verify(
      () => mockInvoiceRepo.updateNumbering(prefix: 'INV-', nextSequence: 20),
    ).called(1);
    expect(find.text('Invoice numbering updated'), findsOneWidget);
    expect(find.text('Next: INV-0020'), findsOneWidget);
  });

  testWidgets('fits in Bangla at 2x font', (tester) async {
    await pump(tester, language: 'bn', textScale: 2);
    expect(find.text('সেটিংস'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
