import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/database/app_database.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/business_profile/data/mappers/business_profile_mapper.dart';
import 'package:receipt_maker/features/business_profile/domain/models/business_profile.dart';
import 'package:receipt_maker/features/clients/data/mappers/client_mapper.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:receipt_maker/features/invoices/domain/models/bill_to.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount.dart';
import 'package:receipt_maker/features/invoices/domain/models/discount_type.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';

void main() {
  late AppDatabase db;
  late InvoiceRepositoryImpl repo;
  final t = DateTime.utc(2026, 10, 20, 8);
  final day = CalendarDate(2026, 10, 20);

  Invoice invoice(
    String id,
    String number, {
    CalendarDate? issue,
    String? clientId,
    BillTo? billTo,
    List<LineItem>? lines,
  }) => Invoice(
    id: id,
    number: number,
    currencyCode: 'BDT',
    issueDate: issue ?? day,
    dueDate: (issue ?? day).addDays(7),
    createdAt: t,
    updatedAt: t,
    clientId: clientId,
    billTo: billTo,
    lines:
        lines ??
        [LineItem(id: '$id-l1', name: 'Design', unitPriceMinor: 50000)],
  );

  Future<String?> suggested() async => (await repo.suggestNumber()).valueOrNull;

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repo = InvoiceRepositoryImpl(db.invoiceDao, db.businessProfileDao);
    await db.businessProfileDao.upsert(
      BusinessProfile(
        id: 'p',
        name: 'Shop',
        createdAt: t,
        updatedAt: t,
      ).toRow(),
    );
  });
  tearDown(() => db.close());

  test(
    'round-trips lines in order, discounts, tax, dates and bill-to',
    () async {
      final inv =
          invoice(
            'a',
            ' INV-0001 ',
            billTo: const BillTo(name: ' Karim ', phone: '017'),
            lines: [
              const LineItem(id: 'l2', name: 'Second', quantityMilli: 2500),
              const LineItem(
                id: 'l1',
                name: 'First',
                unitPriceMinor: 12345,
                discount: Discount(type: DiscountType.percent, value: 1000),
              ),
            ],
          ).copyWith(
            discount: const Discount(type: DiscountType.flat, value: 500),
            taxRateBasisPoints: 750,
            taxInclusive: true,
            shippingMinor: 6000,
            stage: InvoiceStage.sent,
          );
      expect((await repo.save(inv)).isOk, isTrue);

      final found = (await repo.find('a')).valueOrNull!;
      expect(found.number, 'INV-0001');
      expect(found.billTo, const BillTo(name: 'Karim', phone: '017'));
      expect(found.lines.map((l) => l.id), ['l2', 'l1']);
      expect(found.lines.first.quantityMilli, 2500);
      expect(found.lines.last.discount?.value, 1000);
      expect(found.issueDate, day);
      expect(found.dueDate, day.addDays(7));
      expect(found.stage, InvoiceStage.sent);
      expect(found.taxInclusive, isTrue);
      expect(
        found.discount,
        const Discount(type: DiscountType.flat, value: 500),
      );
    },
  );

  test('stores the computed total for lists', () async {
    await repo.save(
      invoice('a', 'INV-0001').copyWith(taxRateBasisPoints: 1500),
    );
    final list = await repo.watchAll().first;
    expect(list.single.totalMinor, 57500);
  });

  test('numbers advance and are never reused after delete', () async {
    expect(await suggested(), 'INV-0001');
    await repo.save(invoice('a', 'INV-0001'));
    expect(await suggested(), 'INV-0002');
    await repo.delete('a');
    expect(await suggested(), 'INV-0002');
  });

  test('editing an invoice does not advance the number', () async {
    await repo.save(invoice('a', 'INV-0001'));
    await repo.save(invoice('a', 'INV-0001').copyWith(notes: 'edited'));
    expect(await suggested(), 'INV-0002');
  });

  test(
    'a hand-typed number further ahead moves the sequence past it',
    () async {
      await repo.save(invoice('a', 'INV-0100'));
      expect(await suggested(), 'INV-0101');
      await repo.save(invoice('b', 'Special-7'));
      expect(await suggested(), 'INV-0101');
    },
  );

  test('a duplicate number fails with ValidationFailure', () async {
    await repo.save(invoice('a', 'INV-0001'));
    final result = await repo.save(invoice('b', 'INV-0001'));
    final failure = (result as Err<Invoice>).failure;
    expect(failure, isA<ValidationFailure>());
    expect((failure as ValidationFailure).field, 'number');
    expect((await repo.find('b')).isOk, isFalse);
  });

  test('saving replaces the lines', () async {
    await repo.save(invoice('a', 'INV-0001'));
    await repo.save(
      invoice(
        'a',
        'INV-0001',
        lines: [const LineItem(id: 'n', name: 'New')],
      ),
    );
    final lines = await db.select(db.invoiceLinesTable).get();
    expect(lines.map((l) => l.id), ['n']);
  });

  test('deleting removes the lines too', () async {
    await repo.save(invoice('a', 'INV-0001'));
    await repo.delete('a');
    expect(await db.select(db.invoiceLinesTable).get(), isEmpty);
  });

  test('deleting the client keeps the bill-to copy', () async {
    await db.clientDao.upsert(
      Client(id: 'c', name: 'Karim', createdAt: t, updatedAt: t).toRow(),
    );
    await repo.save(
      invoice(
        'a',
        'INV-0001',
        clientId: 'c',
        billTo: const BillTo(name: 'Karim'),
      ),
    );
    await db.clientDao.deleteById('c');
    final found = (await repo.find('a')).valueOrNull!;
    expect(found.clientId, isNull);
    expect(found.billTo?.name, 'Karim');
  });

  test('lists newest first and searches number and client', () async {
    await repo.save(
      invoice('a', 'INV-0001', billTo: const BillTo(name: 'Karim')),
    );
    await repo.save(
      invoice(
        'b',
        'INV-0002',
        issue: day.addDays(1),
        billTo: const BillTo(name: 'রহমান'),
      ),
    );
    Future<List<String>> numbers([String q = '']) async =>
        (await repo.watchAll(query: q).first).map((s) => s.number).toList();
    expect(await numbers(), ['INV-0002', 'INV-0001']);
    expect(await numbers('0001'), ['INV-0001']);
    expect(await numbers('রহমান'), ['INV-0002']);
    expect(await numbers('kar'), ['INV-0001']);
  });

  test('watch emits the invoice, then null after delete', () async {
    await repo.save(invoice('a', 'INV-0001'));
    final seen = <String?>[];
    final sub = repo.watch('a').listen((i) => seen.add(i?.number));
    await pumpEventQueue();
    await repo.delete('a');
    await pumpEventQueue();
    await sub.cancel();
    expect(seen, ['INV-0001', null]);
  });

  test('saving without a business profile fails', () async {
    await db.delete(db.businessProfilesTable).go();
    final result = await repo.save(invoice('a', 'INV-0001'));
    expect((result as Err<Invoice>).failure, isA<NotFoundFailure>());
  });
}
