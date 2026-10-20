import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/provider_retry.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/services/clock.dart';
import 'package:receipt_maker/core/services/service_providers.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/core/utils/validation_error.dart';
import 'package:receipt_maker/features/business_profile/business_profile.dart';
import 'package:receipt_maker/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:receipt_maker/features/invoices/domain/models/due_term.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_field.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/presentation/view_models/invoice_editor_state.dart';
import 'package:receipt_maker/features/invoices/presentation/view_models/invoice_editor_view_model.dart';
import 'package:receipt_maker/features/invoices/providers.dart';

import '../../../helpers/fake_app_preferences.dart';
import '../../../helpers/mock_repositories.dart';

void main() {
  setUpAll(registerRepositoryFallbacks);

  late MockInvoiceRepository repo;
  late MockBusinessProfileRepository profiles;
  late ProviderContainer container;
  final now = DateTime(2026, 10, 20, 15);
  final today = CalendarDate(2026, 10, 20);

  Future<InvoiceEditorViewModelProvider> open({
    String? id,
    String? copyOf,
  }) async {
    final provider = invoiceEditorViewModelProvider(id, copyOf);
    container = ProviderContainer(
      overrides: [
        invoiceRepositoryProvider.overrideWithValue(repo),
        businessProfileRepositoryProvider.overrideWithValue(profiles),
        appPreferencesProvider.overrideWithValue(
          FakeAppPreferences(defaultCurrency: 'BDT'),
        ),
        clockProvider.overrideWithValue(() => now),
      ],
      retry: appProviderRetry,
    )..listen(provider, (_, _) {});
    await container.read(provider.future);
    return provider;
  }

  InvoiceEditorState form(InvoiceEditorViewModelProvider p) =>
      container.read(p).requireValue;

  setUp(() {
    repo = MockInvoiceRepository();
    profiles = MockBusinessProfileRepository();
    when(() => repo.suggestNumber())
        .thenAnswer((_) async => const Ok('INV-0007'));
    when(() => repo.save(any()))
        .thenAnswer((i) async => Ok(i.positionalArguments.first as Invoice));
    when(() => profiles.load()).thenAnswer(
      (_) async => Ok(
        BusinessProfile(
          id: 'p',
          name: 'Shop',
          createdAt: testTime,
          updatedAt: testTime,
          defaultNotes: 'Thanks!',
          defaultTerms: 'Pay in 7 days',
          paymentInstructions: 'bKash 017',
        ),
      ),
    );
  });
  tearDown(() => container.dispose());

  test('a new invoice is prefilled and not yet changed', () async {
    final p = await open();
    final f = form(p);
    expect(f.draft.number, 'INV-0007');
    expect(f.draft.issueDate, today);
    expect(f.draft.dueDate, today.addDays(7));
    expect(f.dueTerm, DueTerm.days7);
    expect(f.draft.currencyCode, 'BDT');
    expect(f.draft.notes, 'Thanks!');
    expect(f.draft.terms, 'Pay in 7 days');
    expect(f.draft.paymentInstructions, 'bKash 017');
    expect(f.hasUnsavedChanges, isFalse);
  });

  test('saving needs at least one line', () async {
    final p = await open();
    expect(await container.read(p.notifier).save(), isNull);
    expect(form(p).errorFor(InvoiceField.lines), ValidationError.noLines);
    verifyNever(() => repo.save(any()));
  });

  test('adding an item copies its price, unit and default tax', () async {
    final p = await open();
    final vm = container.read(p.notifier);
    final added = vm.addItem(
      testItem().copyWith(unit: 'pcs', defaultTaxBasisPoints: 1500),
    );
    expect(added.needsPrice, isFalse);
    final line = form(p).draft.lines.single;
    expect(line.unitPriceMinor, 500000);
    expect(line.unit, 'pcs');
    expect(line.itemId, 'i1');
    expect(form(p).draft.taxRateBasisPoints, 1500);
    expect(form(p).totals.total, 575000);
  });

  test(
    'the first item sets the currency; later foreign items need a price',
    () async {
      final p = await open();
      final vm = container.read(p.notifier)
        ..addItem(testItem(currency: 'USD', price: 2500));
      expect(form(p).draft.currencyCode, 'USD');
      expect(form(p).draft.lines.single.unitPriceMinor, 2500);

      final added = vm.addItem(
        testItem(id: 'i2', currency: 'JPY', price: 1500),
      );
      expect(added.needsPrice, isTrue);
      expect(form(p).draft.lines.last.unitPriceMinor, 0);
      expect(form(p).foreignPriceLines, {added.lineId: 'JPY'});

      vm.setLinePrice(added.lineId, 1200);
      expect(form(p).foreignPriceLines, isEmpty);
    },
  );

  test('changing currency keeps the face value', () async {
    final p = await open();
    container.read(p.notifier)
      ..addItem(testItem(price: 50000))
      ..setCurrency('JPY');
    expect(form(p).draft.lines.single.unitPriceMinor, 500);
  });

  test('a preset due term follows the issue date', () async {
    final p = await open();
    final vm = container.read(p.notifier)
      ..setDueTerm(DueTerm.days30)
      ..setIssueDate(today.addDays(2));
    expect(form(p).draft.dueDate, today.addDays(32));
    vm.setDueDate(today.addDays(3));
    expect(form(p).dueTerm, DueTerm.custom);
  });

  test('saving stores the draft and clears unsaved changes', () async {
    final p = await open();
    final vm = container.read(p.notifier)..addItem(testItem());
    expect(form(p).hasUnsavedChanges, isTrue);
    final saved = await vm.save();
    expect(saved?.number, 'INV-0007');
    expect(saved?.stage, InvoiceStage.draft);
    expect(form(p).hasUnsavedChanges, isFalse);
    expect(form(p).isNew, isFalse);
  });

  test('a duplicate number shows on the number field', () async {
    when(() => repo.save(any())).thenAnswer(
      (_) async =>
          const Err(ValidationFailure(InvoiceRepositoryImpl.numberField)),
    );
    final p = await open();
    final vm = container.read(p.notifier)..addItem(testItem());
    expect(await vm.save(), isNull);
    expect(form(p).errorFor(InvoiceField.number), ValidationError.numberTaken);
    vm.setNumber('INV-0099');
    expect(form(p).errorFor(InvoiceField.number), isNull);
  });

  test('a failed save keeps the draft and reports the failure', () async {
    when(() => repo.save(any()))
        .thenAnswer((_) async => const Err(DatabaseFailure()));
    final p = await open();
    final vm = container.read(p.notifier)..addItem(testItem());
    expect(await vm.save(), isNull);
    expect(form(p).failure, isA<DatabaseFailure>());
    expect(form(p).hasUnsavedChanges, isTrue);
  });

  test('editing loads the saved invoice', () async {
    when(() => repo.find('inv1')).thenAnswer((_) async => Ok(testInvoice()));
    final p = await open(id: 'inv1');
    expect(form(p).isNew, isFalse);
    expect(form(p).draft.number, 'INV-0001');
    verifyNever(() => repo.suggestNumber());
  });

  test('a copy is a new draft with the next number', () async {
    when(() => repo.find('inv1')).thenAnswer(
      (_) async => Ok(testInvoice().copyWith(stage: InvoiceStage.sent)),
    );
    final p = await open(copyOf: 'inv1');
    final f = form(p);
    expect(f.isNew, isTrue);
    expect(f.draft.id, isNot('inv1'));
    expect(f.draft.number, 'INV-0007');
    expect(f.draft.stage, InvoiceStage.draft);
    expect(f.draft.issueDate, today);
    expect(f.draft.lines.single.name, 'Logo design');
    expect(f.hasUnsavedChanges, isTrue, reason: 'leaving asks first');
  });

  test('a one-off line left empty is discarded', () async {
    final p = await open();
    final vm = container.read(p.notifier);
    final id = vm.addBlankLine();
    expect(form(p).draft.lines, hasLength(1));
    vm.discardLineIfBlank(id);
    expect(form(p).draft.lines, isEmpty);

    final kept = vm.addBlankLine();
    vm
      ..setLineName(kept, 'Delivery')
      ..discardLineIfBlank(kept);
    expect(form(p).draft.lines.single.name, 'Delivery');
  });
}
