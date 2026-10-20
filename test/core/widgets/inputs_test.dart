import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/core/widgets/inputs/amount_field.dart';
import 'package:receipt_maker/core/widgets/inputs/date_field.dart';
import 'package:receipt_maker/core/widgets/inputs/dropdown_field.dart';

import '../../helpers/pump_app.dart';

void main() {
  setUpAll(initializeDateFormatting);

  group('AmountField', () {
    late List<int?> values;
    setUp(() => values = []);

    Future<void> pump(WidgetTester tester, String currency) => tester.pumpApp(
      AmountField(
        label: 'Price',
        currencyCode: currency,
        onChanged: values.add,
      ),
    );

    testWidgets('reports minor units', (tester) async {
      await pump(tester, 'BDT');
      await tester.enterText(find.byType(TextField), '1,234.5');
      expect(values.last, 123450);
      expect(find.text('৳'), findsOneWidget);
    });

    testWidgets('converts Bangla digits as typed', (tester) async {
      await pump(tester, 'BDT');
      await tester.enterText(find.byType(TextField), '১২.৫');
      expect(values.last, 1250);
      expect(find.text('12.5'), findsOneWidget);
    });

    testWidgets('rejects letters and extra decimals', (tester) async {
      await pump(tester, 'BDT');
      await tester.enterText(find.byType(TextField), '12.34');
      await tester.enterText(find.byType(TextField), '12.345');
      await tester.enterText(find.byType(TextField), '12.34x');
      expect(find.text('12.34'), findsOneWidget);
      expect(values.last, 1234);
    });

    testWidgets('JPY has no decimals', (tester) async {
      await pump(tester, 'JPY');
      await tester.enterText(find.byType(TextField), '1500');
      await tester.enterText(find.byType(TextField), '1500.');
      expect(find.text('1500'), findsOneWidget);
      expect(values.last, 1500);
    });

    testWidgets('shows the initial value for editing', (tester) async {
      await tester.pumpApp(
        AmountField(
          label: 'Price',
          currencyCode: 'BDT',
          initialMinor: 123450,
          onChanged: values.add,
        ),
      );
      expect(find.text('1234.50'), findsOneWidget);
    });
  });

  testWidgets('DateField shows Bangla digits and opens the picker', (
    tester,
  ) async {
    DateTime? picked;
    await tester.pumpApp(
      DateField(
        label: 'Due',
        value: DateTime(2026, 10, 20),
        onChanged: (d) => picked = d,
      ),
      language: 'bn',
    );
    expect(find.textContaining('২০২৬'), findsOneWidget);
    await tester.tap(find.byType(DateField));
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('২১'));
    await tester.tap(find.text('ঠিক আছে').last);
    await tester.pumpAndSettle();
    expect(picked, DateTime(2026, 10, 21));
  });

  testWidgets('DropdownField reports the chosen value', (tester) async {
    String? chosen;
    await tester.pumpApp(
      DropdownField<String>(
        label: 'Currency',
        value: 'BDT',
        options: const [('BDT', 'Taka'), ('USD', 'Dollar')],
        onChanged: (v) => chosen = v,
      ),
    );
    await tester.tap(find.text('Taka'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dollar').last);
    await tester.pumpAndSettle();
    expect(chosen, 'USD');
  });
}
