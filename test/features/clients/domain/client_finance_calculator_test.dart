import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/clients/domain/logic/client_finance_calculator.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_summary.dart';

void main() {
  group('ClientFinanceCalculator', () {
    test('empty invoices returns zeroed summary with default currency', () {
      final result = ClientFinanceCalculator.calculate(
        [],
        defaultCurrency: 'BDT',
      );

      expect(result.totalBilledMinor, 0);
      expect(result.totalPaidMinor, 0);
      expect(result.balanceMinor, 0);
      expect(result.currencyCode, 'BDT');
      expect(result.invoiceCount, 0);
    });

    test('single invoice computes correct billed, paid, and balance', () {
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

      final result = ClientFinanceCalculator.calculate(
        invoices,
        defaultCurrency: 'BDT',
      );

      expect(result.totalBilledMinor, 500000);
      expect(result.totalPaidMinor, 200000);
      expect(result.balanceMinor, 300000);
      expect(result.currencyCode, 'BDT');
      expect(result.invoiceCount, 1);
    });

    test('sent invoices are summed; a draft is counted but not billed', () {
      final invoices = [
        InvoiceSummary(
          id: 'inv1',
          number: 'INV-0001',
          currencyCode: 'USD',
          issueDate: CalendarDate(2026, 10, 1),
          dueDate: CalendarDate(2026, 10, 8),
          stage: InvoiceStage.sent,
          totalMinor: 10000,
          paidMinor: 10000,
        ),
        InvoiceSummary(
          id: 'inv2',
          number: 'INV-0002',
          currencyCode: 'USD',
          issueDate: CalendarDate(2026, 10, 5),
          dueDate: CalendarDate(2026, 10, 12),
          stage: InvoiceStage.sent,
          totalMinor: 25000,
          paidMinor: 5000,
        ),
        InvoiceSummary(
          id: 'inv3',
          number: 'INV-0003',
          currencyCode: 'USD',
          issueDate: CalendarDate(2026, 10, 10),
          dueDate: CalendarDate(2026, 10, 17),
          stage: InvoiceStage.draft,
          totalMinor: 15000,
        ),
      ];

      final result = ClientFinanceCalculator.calculate(
        invoices,
        defaultCurrency: 'BDT',
      );

      expect(result.totalBilledMinor, 35000, reason: 'the draft is left out');
      expect(result.totalPaidMinor, 15000);
      expect(result.balanceMinor, 20000);
      expect(result.currencyCode, 'USD');
      expect(result.invoiceCount, 3);
    });

    test('currencies are never added together', () {
      InvoiceSummary inv(String id, String currency, int total) =>
          InvoiceSummary(
            id: id,
            number: id,
            currencyCode: currency,
            issueDate: CalendarDate(2026, 10, 1),
            dueDate: CalendarDate(2026, 10, 8),
            stage: InvoiceStage.sent,
            totalMinor: total,
          );
      final result = ClientFinanceCalculator.calculate([
        inv('a', 'USD', 10000),
        inv('b', 'BDT', 500000),
        inv('c', 'BDT', 200000),
      ], defaultCurrency: 'BDT');

      expect(result.currencyCode, 'BDT', reason: 'the default when present');
      expect(result.totalBilledMinor, 700000);
      expect(result.invoiceCount, 3);
    });
  });
}
