import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/clients/presentation/view_models/client_detail_state.dart';
import 'package:receipt_maker/features/clients/presentation/view_models/client_detail_view_model.dart';
import 'package:receipt_maker/features/clients/providers.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_summary.dart';
import 'package:receipt_maker/features/invoices/providers.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';

void main() {
  late MockClientRepository mockClientRepo;
  late MockInvoiceRepository mockInvoiceRepo;
  late FakeAppPreferences fakePrefs;
  late ProviderContainer container;

  setUp(() {
    mockClientRepo = MockClientRepository();
    mockInvoiceRepo = MockInvoiceRepository();
    fakePrefs = FakeAppPreferences(defaultCurrency: 'BDT');
    container = ProviderContainer(
      overrides: [
        clientRepositoryProvider.overrideWithValue(mockClientRepo),
        invoiceRepositoryProvider.overrideWithValue(mockInvoiceRepo),
        appPreferencesProvider.overrideWithValue(fakePrefs),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('client detail aggregates client info and invoices', () async {
    final client = testClient(name: 'Karim Store');
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
      InvoiceSummary(
        id: 'inv2',
        number: 'INV-0002',
        currencyCode: 'BDT',
        issueDate: CalendarDate(2026, 10, 5),
        dueDate: CalendarDate(2026, 10, 12),
        stage: InvoiceStage.sent,
        totalMinor: 300000,
        paidMinor: 300000,
      ),
    ];

    when(() => mockClientRepo.watch('c1'))
        .thenAnswer((_) => Stream.value(client));
    when(() => mockInvoiceRepo.watchByClient('c1'))
        .thenAnswer((_) => Stream.value(invoices));

    final completer = Completer<ClientDetailState>();
    final sub = container.listen(clientDetailViewModelProvider('c1'), (
      _,
      next,
    ) {
      if (next.hasValue && next.value!.invoices.isNotEmpty) {
        if (!completer.isCompleted) completer.complete(next.value);
      }
    });
    final state = await completer.future;
    sub.close();

    expect(state.client?.name, 'Karim Store');
    expect(state.invoices.length, 2);
    expect(state.finances.totalBilledMinor, 800000);
    expect(state.finances.totalPaidMinor, 500000);
    expect(state.finances.balanceMinor, 300000);
    expect(state.finances.currencyCode, 'BDT');
  });
}
