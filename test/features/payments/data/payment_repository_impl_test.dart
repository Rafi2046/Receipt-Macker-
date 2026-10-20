import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/database/app_database.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/core/errors/result.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/business_profile/data/mappers/business_profile_mapper.dart';
import 'package:receipt_maker/features/business_profile/domain/models/business_profile.dart';
import 'package:receipt_maker/features/invoices/data/repositories/invoice_repository_impl.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice.dart';
import 'package:receipt_maker/features/invoices/domain/models/line_item.dart';
import 'package:receipt_maker/features/payments/data/repositories/payment_repository_impl.dart';
import 'package:receipt_maker/features/payments/domain/models/payment.dart';
import 'package:receipt_maker/features/payments/domain/models/payment_method.dart';

void main() {
  late AppDatabase db;
  late InvoiceRepositoryImpl invoices;
  late PaymentRepositoryImpl payments;
  final t = DateTime.utc(2026, 10, 20, 8);
  final day = CalendarDate(2026, 10, 20);

  Payment pay(
    String id,
    int amount, {
    PaymentMethod method = PaymentMethod.cash,
  }) => Payment(
    id: id,
    invoiceId: 'inv',
    amountMinor: amount,
    paidOn: day,
    method: method,
    createdAt: t,
    updatedAt: t,
  );

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    invoices = InvoiceRepositoryImpl(db.invoiceDao, db.businessProfileDao);
    payments = PaymentRepositoryImpl(db, db.paymentDao, db.invoiceDao);
    await db.businessProfileDao.upsert(
      BusinessProfile(
        id: 'p',
        name: 'Shop',
        createdAt: t,
        updatedAt: t,
      ).toRow(),
    );
    await invoices.save(
      Invoice(
        id: 'inv',
        number: 'INV-0001',
        currencyCode: 'BDT',
        issueDate: day,
        dueDate: day.addDays(7),
        createdAt: t,
        updatedAt: t,
        lines: const [LineItem(id: 'l', name: 'Design', unitPriceMinor: 50000)],
      ),
    );
  });

  tearDown(() => db.close());

  test('partial then rest pays the invoice; numbers are not reused', () async {
    expect(
      (await payments.save(pay('a', 20000))).valueOrNull?.receiptNumber,
      'RCPT-0001',
    );
    expect(
      (await payments.save(pay('b', 30000, method: PaymentMethod.bkash)))
          .valueOrNull
          ?.receiptNumber,
      'RCPT-0002',
    );
    expect((await invoices.find('inv')).valueOrNull?.paidMinor, 50000);

    expect((await payments.delete('a')).isOk, isTrue);
    expect((await invoices.find('inv')).valueOrNull?.paidMinor, 30000);
    final next = await payments.save(pay('c', 20000));
    expect(next.valueOrNull?.receiptNumber, 'RCPT-0003');
  });

  test('overpayment is blocked; editing stays inside the balance', () async {
    await payments.save(pay('a', 20000));
    final tooMuch = await payments.save(pay('b', 30001));
    expect(tooMuch.failure, isA<ValidationFailure>());

    final raised = await payments.save(pay('a', 50000));
    expect(raised.isOk, isTrue);
    expect(raised.valueOrNull?.receiptNumber, 'RCPT-0001');
    expect((await invoices.find('inv')).valueOrNull?.paidMinor, 50000);

    final overEdit = await payments.save(pay('a', 50001));
    expect(overEdit.failure, isA<ValidationFailure>());
  });

  test('saving the invoice does not wipe the paid amount', () async {
    await payments.save(pay('a', 15000));
    final invoice = (await invoices.find('inv')).valueOrNull!;
    await invoices.save(invoice.copyWith(notes: 'Thanks', paidMinor: 0));
    expect((await invoices.find('inv')).valueOrNull?.paidMinor, 15000);
  });

  test('deleting the invoice removes its payments', () async {
    await payments.save(pay('a', 1000));
    await invoices.delete('inv');
    expect(await db.select(db.paymentsTable).get(), isEmpty);
  });
}

extension on Result<Payment> {
  Failure? get failure => switch (this) {
    Ok() => null,
    Err(:final failure) => failure,
  };
}
