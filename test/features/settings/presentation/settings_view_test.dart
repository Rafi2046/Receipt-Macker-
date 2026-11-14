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
    when(() => mockInvoiceRepo.getHighestSequence('INV-'))
        .thenAnswer((_) async => const Ok(4));
  });

  testWidgets('renders settings view in English', (tester) async {
    await tester.pumpApp(
      const SettingsView(),
      surface: const Size(800, 1400),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
      ],
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Appearance & Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('বাংলা'), findsOneWidget);
    expect(find.text('Default invoice terms'), findsOneWidget);
    expect(find.text('Invoice numbering'), findsOneWidget);
    expect(find.text('Save numbering'), findsOneWidget);
  });

  testWidgets('renders settings view in Bangla', (tester) async {
    await tester.pumpApp(
      const SettingsView(),
      language: 'bn',
      surface: const Size(800, 1400),
      overrides: [
        appPreferencesProvider.overrideWithValue(fakePrefs),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
      ],
    );

    expect(find.text('সেটিংস'), findsOneWidget);
    expect(find.text('চেহারা ও ভাষা'), findsOneWidget);
    expect(find.text('চালানের ডিফল্ট শর্ত'), findsOneWidget);
    expect(find.text('চালান নম্বর নির্ধারণ'), findsOneWidget);
    expect(find.text('নম্বর সংরক্ষণ করুন'), findsOneWidget);
  });
}
