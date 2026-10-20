import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/provider_retry.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/clock.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_status.dart';
import 'package:receipt_maker/features/invoices/presentation/view_models/invoice_detail_view_model.dart';
import 'package:receipt_maker/features/invoices/providers.dart';

import '../../../helpers/mock_repositories.dart';

void main() {
  setUpAll(registerRepositoryFallbacks);

  late MockInvoiceRepository repo;
  late ProviderContainer container;
  late StreamController<Invoice?> stream;
  final provider = invoiceDetailViewModelProvider('inv1');

  void open(DateTime now) {
    container = ProviderContainer(
      overrides: [
        invoiceRepositoryProvider.overrideWithValue(repo),
        clockProvider.overrideWithValue(() => now),
      ],
      retry: appProviderRetry,
    )..listen(provider, (_, _) {});
  }

  Future<void> emit(Invoice? invoice) async {
    stream.add(invoice);
    await pumpEventQueue();
  }

  setUp(() {
    repo = MockInvoiceRepository();
    stream = StreamController<Invoice?>.broadcast();
    when(() => repo.watch('inv1')).thenAnswer((_) => stream.stream);
    when(() => repo.save(any()))
        .thenAnswer((i) async => Ok(i.positionalArguments.first as Invoice));
  });
  tearDown(() async {
    container.dispose();
    await stream.close();
  });

  test('works out totals and status for today', () async {
    open(DateTime(2026, 10, 28, 9)); // the day after the due date
    await emit(testInvoice().copyWith(stage: InvoiceStage.sent));
    final s = container.read(provider).value;
    expect(s?.totals.total, 500000);
    expect(s?.status, InvoiceStatus.overdue);
  });

  test('a draft stays a draft and can be marked as sent', () async {
    open(DateTime(2026, 10, 21));
    await emit(testInvoice());
    expect(container.read(provider).value?.status, InvoiceStatus.draft);

    final result = await container
        .read(provider.notifier)
        .setStage(InvoiceStage.sent);
    expect(result.isOk, isTrue);
    final saved =
        verify(() => repo.save(captureAny())).captured.single as Invoice;
    expect(saved.stage, InvoiceStage.sent);
  });

  test('a deleted invoice ends in an error state', () async {
    open(DateTime(2026, 10, 21));
    await emit(null);
    expect(container.read(provider).hasError, isTrue);
  });
}
