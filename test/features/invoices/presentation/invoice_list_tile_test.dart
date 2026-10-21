import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/utils/calendar_date.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_stage.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_status.dart';
import 'package:receipt_maker/features/invoices/domain/models/invoice_summary.dart';
import 'package:receipt_maker/features/invoices/presentation/view_models/invoice_list_state.dart';
import 'package:receipt_maker/features/invoices/presentation/widgets/invoice_list_tile.dart';

import '../../../helpers/pump_app.dart';

void main() {
  InvoiceListEntry entry({
    String client = 'Rahman Traders',
    InvoiceStatus status = InvoiceStatus.draft,
  }) => InvoiceListEntry(
    summary: InvoiceSummary(
      id: '1',
      number: 'INV-0001',
      currencyCode: 'BDT',
      issueDate: CalendarDate(2026, 10, 21),
      dueDate: CalendarDate(2026, 10, 28),
      stage: InvoiceStage.draft,
      totalMinor: 10881438,
      clientName: client,
    ),
    status: status,
  );

  testWidgets('client and number share a left edge, amount and status a '
      'right edge', (tester) async {
    await tester.pumpApp(
      InvoiceListTile(entry: entry(), onTap: () {}),
      surface: const Size(411, 800),
    );
    final client = tester.getRect(find.text('Rahman Traders'));
    final number = tester.getRect(
      find.textContaining('INV-0001', findRichText: true),
    );
    final amount = tester.getRect(find.text('৳108,814.38'));
    final status = tester.getRect(find.text('Draft'));
    expect(number.left, client.left);
    // The chip pads its label, so compare the chip's outer edge.
    final chip = tester.getRect(
      find
          .ancestor(of: find.text('Draft'), matching: find.byType(DecoratedBox))
          .first,
    );
    expect(chip.right, closeTo(amount.right, 1));
    expect(status.right, lessThan(chip.right));
  });

  testWidgets('a long Bangla client fits on a narrow phone at 2x', (
    tester,
  ) async {
    await tester.pumpApp(
      InvoiceListTile(
        entry: entry(
          client: 'মেসার্স রহমান অ্যান্ড সন্স (ক্ষুদ্র ও মাঝারি শিল্প)',
          status: InvoiceStatus.partiallyPaid,
        ),
        onTap: () {},
      ),
      language: 'bn',
      textScale: 2,
      surface: const Size(360, 740),
    );
    expect(tester.takeException(), isNull);
  });
}
