import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/clients/presentation/views/client_detail_view.dart';
import 'package:receipt_maker/features/clients/providers.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_summary.dart';
import 'package:receipt_maker/features/invoices/providers.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late MockClientRepository mockClientRepo;
  late MockInvoiceRepository mockInvoiceRepo;
  late FakeAppPreferences fakePrefs;

  setUp(() {
    mockClientRepo = MockClientRepository();
    mockInvoiceRepo = MockInvoiceRepository();
    fakePrefs = FakeAppPreferences();
  });

  testWidgets('renders client detail and financial cards in English', (
    tester,
  ) async {
    final client = testClient(name: 'Karim Store')
        .copyWith(phone: '01712345678', email: 'karim@example.com');
    final invoices = [
      InvoiceSummary(
        id: 'inv1',
        number: 'INV-0001',
        currencyCode: 'BDT',
        issueDate: CalendarDate(2026, 10, 1),
        dueDate: CalendarDate(2026, 10, 8),
        stage: InvoiceStage.sent,
        totalMinor: 500000,
        paidMinor: 200000,
      ),
    ];

    when(() => mockClientRepo.watch('c1'))
        .thenAnswer((_) => Stream.value(client));
    when(() => mockInvoiceRepo.watchByClient('c1'))
        .thenAnswer((_) => Stream.value(invoices));

    await tester.pumpApp(
      const ClientDetailView(clientId: 'c1'),
      surface: const Size(800, 1400),
      overrides: [
        clientRepositoryProvider.overrideWithValue(mockClientRepo),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
        appPreferencesProvider.overrideWithValue(fakePrefs),
      ],
    );

    expect(find.text('Karim Store'), findsWidgets);
    expect(find.text('01712345678'), findsOneWidget);
    expect(find.text('karim@example.com'), findsOneWidget);
    expect(find.text('Total Billed'), findsOneWidget);
    expect(find.text('Total Paid'), findsOneWidget);
    expect(find.text('Outstanding Balance'), findsOneWidget);
    expect(find.text('Call'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(find.textContaining('INV-0001', findRichText: true), findsOneWidget);
  });

  testWidgets('renders client detail in Bangla', (tester) async {
    final client = testClient(name: 'করিম স্টোর')
        .copyWith(phone: '01712345678');

    when(() => mockClientRepo.watch('c1'))
        .thenAnswer((_) => Stream.value(client));
    when(() => mockInvoiceRepo.watchByClient('c1'))
        .thenAnswer((_) => Stream.value([]));

    await tester.pumpApp(
      const ClientDetailView(clientId: 'c1'),
      language: 'bn',
      overrides: [
        clientRepositoryProvider.overrideWithValue(mockClientRepo),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
        appPreferencesProvider.overrideWithValue(fakePrefs),
      ],
    );

    expect(find.text('করিম স্টোর'), findsWidgets);
    expect(find.text('কল'), findsOneWidget);
    expect(find.text('হোয়াটসঅ্যাপ'), findsOneWidget);
    expect(find.text('মোট বিল'), findsOneWidget);
    expect(find.text('মোট পরিশোধ'), findsOneWidget);
    expect(find.text('বকেয়া ব্যালেন্স'), findsOneWidget);
  });
}
