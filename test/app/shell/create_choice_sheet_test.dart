import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/app/shell/create_choice_sheet.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('offers an invoice and an estimate, fits at 2x in Bangla', (
    tester,
  ) async {
    await tester.pumpApp(
      Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () => CreateChoiceSheet.show(context),
            child: const Text('open'),
          ),
        ),
      ),
      language: 'bn',
      textScale: 2,
      surface: const Size(360, 640),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('নতুন ইনভয়েস'), findsOneWidget);
    expect(find.text('নতুন কোটেশন'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
