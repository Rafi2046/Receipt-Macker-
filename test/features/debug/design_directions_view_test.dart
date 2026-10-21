import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/features/debug/presentation/views/design_directions_view.dart';

import '../../helpers/pump_app.dart';

void main() {
  setUpAll(initializeDateFormatting);

  testWidgets('home shows the outstanding hero', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      surface: const Size(411, 914),
    );
    expect(find.text('Outstanding'), findsOneWidget);
    expect(find.text('Good evening, Rahman'), findsOneWidget);
    expect(find.textContaining('৳26,500.00'), findsWidgets);
  });

  testWidgets('More shows both Latin fonts side by side', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      surface: const Size(411, 914),
    );
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Manrope'), findsOneWidget);
    expect(find.text('Plus Jakarta Sans'), findsOneWidget);
    expect(find.text('QuickBill Pro'), findsOneWidget);
  });

  testWidgets('Bangla home uses Bangla digits', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      language: 'bn',
      surface: const Size(411, 914),
    );
    expect(find.textContaining('শুভ সন্ধ্যা'), findsOneWidget);
    expect(find.textContaining('৳২৬,৫০০.০০'), findsWidgets);
  });

  testWidgets('screens fit at 1.3x in light and dark', (tester) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await tester.pumpApp(
        const DesignDirectionsView(),
        themeMode: mode,
        textScale: 1.3,
        surface: const Size(411, 914),
      );
      expect(tester.takeException(), isNull);
      await tester.drag(
        find.byType(ListView).hitTestable().first,
        const Offset(0, -700),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    }
  });
}
