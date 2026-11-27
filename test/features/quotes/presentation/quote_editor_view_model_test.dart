import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';
import 'package:receipt_maker/features/invoices/providers.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';
import 'package:receipt_maker/features/quotes/domain/models/quote.dart';
import 'package:receipt_maker/features/quotes/domain/models/quote_status.dart';
import 'package:receipt_maker/features/quotes/domain/repositories/quote_repository.dart';
import 'package:receipt_maker/features/quotes/presentation/view_models/quote_editor_view_model.dart';
import 'package:receipt_maker/features/quotes/providers.dart';

import '../../../helpers/mock_repositories.dart';

class _MockQuoteRepo extends Mock implements QuoteRepository {}

class _FakeQuote extends Fake implements Quote {}

class _FakeInvoice extends Fake implements Invoice {}

void main() {
  final t = DateTime.utc(2026, 11);
  final day = CalendarDate(2026, 11, 1);

  Quote quote({List<LineItem>? lines, String currency = 'BDT'}) => Quote(
    id: 'q1',
    number: 'EST-0001',
    currencyCode: currency,
    issueDate: day,
    validUntil: day,
    lines:
        lines ??
        const [LineItem(id: 'l1', name: 'Design', unitPriceMinor: 50000)],
    createdAt: t,
    updatedAt: t,
  );

  late _MockQuoteRepo quotes;
  late MockInvoiceRepository invoices;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_FakeQuote());
    registerFallbackValue(_FakeInvoice());
  });

  Future<QuoteEditorViewModel> open(Quote saved) async {
    quotes = _MockQuoteRepo();
    invoices = MockInvoiceRepository();
    when(() => quotes.find('q1')).thenAnswer((_) async => Ok(saved));
    when(() => quotes.save(any()))
        .thenAnswer((i) async => Ok(i.positionalArguments.first as Quote));
    when(() => invoices.suggestNumber())
        .thenAnswer((_) async => const Ok('INV-0009'));
    when(() => invoices.save(any()))
        .thenAnswer((i) async => Ok(i.positionalArguments.first as Invoice));
    container = ProviderContainer(
      overrides: [
        quoteRepositoryProvider.overrideWithValue(quotes),
        invoiceRepositoryProvider.overrideWithValue(invoices),
      ],
    );
    addTearDown(container.dispose);
    await container.read(quoteEditorViewModelProvider('q1').future);
    return container.read(quoteEditorViewModelProvider('q1').notifier);
  }

  QuoteEditorViewModelProvider provider() => quoteEditorViewModelProvider('q1');

  test('convert saves the estimate, makes an invoice and links them', () async {
    final vm = await open(quote());
    final invoiceId = await vm.convertToInvoice();

    expect(invoiceId, isNotNull);
    final made =
        verify(() => invoices.save(captureAny())).captured.single as Invoice;
    expect(made.number, 'INV-0009');
    expect(made.lines.single.unitPriceMinor, 50000);
    final state = container.read(provider()).value!;
    expect(state.draft.convertedInvoiceId, invoiceId);
    expect(state.draft.status, QuoteStatus.approved);
    expect(state.isBusy, isFalse);
  });

  test('an estimate with no lines is not saved or converted', () async {
    final vm = await open(quote(lines: const []));
    expect(await vm.save(), isNull);
    expect(await vm.convertToInvoice(), isNull);
    verifyNever(() => quotes.save(any()));
    verifyNever(() => invoices.save(any()));
    final state = container.read(provider()).value!;
    expect(state.failure, isA<ValidationFailure>());
    expect(state.isBusy, isFalse);
  });

  test('changing currency keeps the face value of prices', () async {
    final vm = await open(quote());
    vm.setCurrency('JPY');
    final draft = container.read(provider()).value!.draft;
    expect(draft.currencyCode, 'JPY');
    expect(draft.lines.single.unitPriceMinor, 500, reason: '৳500.00 → ¥500');
  });

  test('an item priced in another currency comes in without a price', () async {
    final vm = await open(quote());
    vm.addItem(
      Item(
        id: 'i',
        name: 'Hosting',
        unitPriceMinor: 9900,
        currencyCode: 'USD',
        createdAt: t,
        updatedAt: t,
      ),
    );
    final lines = container.read(provider()).value!.draft.lines;
    expect(lines.last.name, 'Hosting');
    expect(lines.last.unitPriceMinor, 0);
  });
}
