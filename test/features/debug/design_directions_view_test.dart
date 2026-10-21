import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/features/debug/presentation/studio/widgets/studio_month_chart.dart';
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
    expect(find.textContaining('৳26,500'), findsWidgets);
  });

  testWidgets('tapping a chart bar shows that month amount', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      surface: const Size(411, 914),
    );
    final chart = find.byType(StudioMonthChart);
    await tester.scrollUntilVisible(
      chart,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    final rect = tester.getRect(chart);
    await tester.tapAt(Offset(rect.left + rect.width / 12, rect.top + 24));
    await tester.pump();
    expect(find.textContaining('৳32,000'), findsOneWidget);
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
    final pro = find.text('QuickBill Pro');
    await tester.scrollUntilVisible(
      pro,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    expect(pro, findsOneWidget);
  });

  testWidgets('Bangla home uses Bangla digits', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      language: 'bn',
      surface: const Size(411, 914),
    );
    expect(find.textContaining('শুভ সন্ধ্যা'), findsOneWidget);
    expect(find.textContaining('৳২৬,৫০০'), findsWidgets);
  });

  testWidgets('invoice design opens the template gallery', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      surface: const Size(411, 914),
    );
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    final tile = find.text('Invoice design');
    await tester.scrollUntilVisible(
      tile,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.textContaining('Recommended'), findsOneWidget);
    expect(find.text('Harbor'), findsOneWidget);
    expect(find.text('PRO'), findsWidgets);
    await tester.tap(find.text('Harbor'));
    await tester.pumpAndSettle();
    expect(find.text('Use this template'), findsOneWidget);
    expect(find.text('1 / 2'), findsOneWidget);
    expect(find.text('2 / 2'), findsOneWidget);
    await tester.tap(find.text('Use this template'));
    await tester.pump();
    expect(find.text('Using this template'), findsOneWidget);
    await tester.tap(find.text('58 mm'));
    await tester.pump();
    expect(find.text('2 / 2'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bangla gallery uses Bangla category names', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      language: 'bn',
      surface: const Size(411, 914),
    );
    await tester.tap(find.text('আরও'));
    await tester.pumpAndSettle();
    final tile = find.text('ইনভয়েস ডিজাইন');
    await tester.scrollUntilVisible(
      tile,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.textContaining('সুপারিশকৃত'), findsOneWidget);
    expect(find.text('প্রো'), findsWidgets);
  });

  testWidgets('invoice settings keeps business defaults', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      surface: const Size(411, 914),
    );
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    final tile = find.text('Invoice settings');
    await tester.scrollUntilVisible(
      tile,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('Added on top'), findsOneWidget);
    expect(find.textContaining('bKash'), findsOneWidget);
    await tester.tap(find.text('Included in the price'));
    await tester.pump();
    final stamp = find.text('Show PAID stamp');
    await tester.scrollUntilVisible(
      stamp,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await tester.tap(stamp);
    await tester.pump();
    final never = find.text('Never');
    await tester.scrollUntilVisible(
      never,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    expect(never, findsOneWidget);
    expect(find.text('INV'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bangla invoice settings uses Bangla labels', (tester) async {
    await tester.pumpApp(
      const DesignDirectionsView(),
      language: 'bn',
      surface: const Size(411, 914),
    );
    await tester.tap(find.text('আরও'));
    await tester.pumpAndSettle();
    final tile = find.text('ইনভয়েস সেটিংস');
    await tester.scrollUntilVisible(
      tile,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    await tester.tap(tile);
    await tester.pumpAndSettle();
    expect(find.text('দামের মধ্যে'), findsOneWidget);
    expect(find.textContaining('০১৭'), findsOneWidget);
    final never = find.text('কখনো না');
    await tester.scrollUntilVisible(
      never,
      400,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    expect(never, findsOneWidget);
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
