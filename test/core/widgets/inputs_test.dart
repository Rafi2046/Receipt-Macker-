import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/core/widgets/inputs/amount_field.dart';
import 'package:receipt_maker/core/widgets/inputs/app_search_field.dart';
import 'package:receipt_maker/core/widgets/inputs/date_field.dart';
import 'package:receipt_maker/core/widgets/inputs/decimal_field.dart';
import 'package:receipt_maker/core/widgets/inputs/dropdown_field.dart';
import 'package:receipt_maker/core/widgets/inputs/percent_field.dart';

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

  group('PercentField', () {
    testWidgets('reports basis points and shows the initial compactly', (
      tester,
    ) async {
      final values = <int?>[];
      await tester.pumpApp(
        PercentField(label: 'Tax', basisPoints: 1500, onChanged: values.add),
      );
      expect(find.text('15'), findsOneWidget);
      expect(find.text('%'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '৭.৫');
      expect(values.last, 750);
      await tester.enterText(find.byType(TextField), '');
      expect(values.last, isNull);
    });
  });

  group('AppSearchField', () {
    testWidgets('clear button appears with text and empties the query', (
      tester,
    ) async {
      final queries = <String>[];
      await tester.pumpApp(
        AppSearchField(hint: 'Search', onChanged: queries.add),
      );
      expect(find.byTooltip('Clear search'), findsNothing);

      await tester.enterText(find.byType(TextField), 'rah');
      await tester.pump();
      await tester.tap(find.byTooltip('Clear search'));
      await tester.pump();
      expect(queries, ['rah', '']);
      expect(find.text('rah'), findsNothing);
    });
  });

  group('DecimalField', () {
    testWidgets('follows a value changed from outside, not while typing', (
      tester,
    ) async {
      final value = ValueNotifier<int?>(null);
      addTearDown(value.dispose);
      await tester.pumpApp(
        ValueListenableBuilder<int?>(
          valueListenable: value,
          builder: (_, v, _) => DecimalField(
            label: 'Tax',
            decimalDigits: 2,
            value: v,
            onChanged: (n) => value.value = n,
          ),
        ),
      );
      value.value = 1500;
      await tester.pump();
      expect(find.text('15'), findsOneWidget, reason: 'set from outside');

      await tester.enterText(find.byType(TextField), '0.');
      await tester.pump();
      expect(find.text('0.'), findsOneWidget, reason: 'typing is kept');
      await tester.enterText(find.byType(TextField), '7.5');
      await tester.pump();
      expect(value.value, 750);
      expect(find.text('7.5'), findsOneWidget);
    });
  });
}
