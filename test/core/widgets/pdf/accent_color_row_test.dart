import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/brand_swatch.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/widgets/pdf/accent_color_row.dart';

import '../../../helpers/pump_app.dart';

void main() {
  late List<String> picked;

  Future<void> pump(WidgetTester tester, {String? selected, String? logo}) {
    picked = [];
    return tester.pumpApp(
      Scaffold(
        body: AccentColorRow(
          selectedHex: selected,
          template: PdfTemplate.values.first,
          logoHex: logo,
          onSelected: picked.add,
        ),
      ),
    );
  }

  testWidgets('tapping a swatch picks its color', (tester) async {
    await pump(tester);
    await tester.tap(find.bySemanticsLabel('Navy'));
    expect(picked, [BrandSwatch.navy.hex]);
  });

  testWidgets('logo color comes first and can be picked', (tester) async {
    await pump(tester, logo: '#1E6FD9');
    expect(find.bySemanticsLabel('Logo color'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Logo color'));
    expect(picked, ['#1E6FD9']);
  });

  testWidgets('custom color sheet returns a typed hex code', (tester) async {
    await pump(tester);
    await tester.tap(find.bySemanticsLabel('Custom color'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '#12AB34');
    await tester.pump();
    await tester.tap(find.text('Use this color'));
    await tester.pumpAndSettle();
    expect(picked, ['#12AB34']);
  });

  testWidgets('a bad hex code shows an error and blocks saving', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.bySemanticsLabel('Custom color'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'nope');
    await tester.pump();
    expect(find.text('Enter a color code like #1E6FD9'), findsOneWidget);
    await tester.tap(find.text('Use this color'));
    await tester.pumpAndSettle();
    expect(picked, isEmpty);
  });
}
