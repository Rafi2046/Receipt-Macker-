import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/provider_retry.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/clock.dart';
import 'package:receipt_maker/features/invoices/providers.dart';
import 'package:receipt_maker/features/payments/domain/models/payment.dart';
import 'package:receipt_maker/features/payments/domain/models/payment_method.dart';
import 'package:receipt_maker/features/payments/presentation/view_models/payment_form_view_model.dart';
import 'package:receipt_maker/features/payments/providers.dart';

import '../../../helpers/mock_repositories.dart';

void main() {
  setUpAll(registerRepositoryFallbacks);

  late MockInvoiceRepository invoices;
  late MockPaymentRepository payments;
  late ProviderContainer container;
  final provider = paymentFormViewModelProvider('inv1', null);

  setUp(() {
    invoices = MockInvoiceRepository();
    payments = MockPaymentRepository();
    when(() => invoices.find('inv1'))
        .thenAnswer((_) async => Ok(testInvoice().copyWith(paidMinor: 200000)));
    when(() => payments.watchForInvoice('inv1'))
        .thenAnswer((_) => Stream.value(const []));
    when(() => payments.save(any()))
        .thenAnswer((i) async => Ok(i.positionalArguments.first as Payment));
    container = ProviderContainer(
      overrides: [
        invoiceRepositoryProvider.overrideWithValue(invoices),
        paymentRepositoryProvider.overrideWithValue(payments),
        clockProvider.overrideWithValue(() => testTime),
      ],
      retry: appProviderRetry,
    );
  });

  tearDown(() => container.dispose());

  test('a new payment starts as the balance, paid today, in cash', () async {
    final form = await container.read(provider.future);
    expect(form.draft.amountMinor, 300000);
    expect(form.draft.method, PaymentMethod.cash);
    expect(form.maxMinor, 300000);
    expect(form.isNew, isTrue);
  });

  test('an amount above the balance is not saved', () async {
    await container.read(provider.future);
    final vm = container.read(provider.notifier);
    vm.setAmount(300001);
    expect(await vm.save(), isNull);
    verifyNever(() => payments.save(any()));
  });

  test('a valid amount is stored', () async {
    await container.read(provider.future);
    final vm = container.read(provider.notifier);
    vm.setAmount(150000);
    final saved = await vm.save();
    expect(saved?.amountMinor, 150000);
    verify(() => payments.save(any())).called(1);
  });
}
