import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/widgets/layout/app_nav_bar.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Widget bar({
    int index = 0,
    List<String> labels = const ['Home', 'Invoices', 'Clients', 'More'],
    ValueChanged<int>? onSelected,
    VoidCallback? onCreate,
  }) => Align(
    alignment: Alignment.bottomCenter,
    child: AppNavBar(
      index: index,
      labels: labels,
      createLabel: 'New invoice',
      onSelected: onSelected ?? (_) {},
      onCreate: onCreate ?? () {},
    ),
  );

  testWidgets('only the selected tab shows its label', (tester) async {
    await tester.pumpApp(bar(index: 1));
    expect(find.text('Invoices'), findsOneWidget);
    // The pill gets room for its whole label, not a sliver of it.
    expect(tester.getSize(find.text('Invoices')).width, greaterThan(40));
    expect(find.text('Home'), findsNothing);
    expect(find.text('Clients'), findsNothing);
  });

  testWidgets('tapping a tab and the create button calls back', (tester) async {
    int? selected;
    var created = false;
    await tester.pumpApp(
      bar(onSelected: (i) => selected = i, onCreate: () => created = true),
    );
    await tester.tap(find.bySemanticsLabel('Clients'));
    await tester.tap(find.byTooltip('New invoice'));
    expect(selected, 2);
    expect(created, isTrue);
  });

  testWidgets('a Bangla label fits on a narrow phone at 2x', (tester) async {
    await tester.pumpApp(
      bar(index: 2, labels: const ['হোম', 'ইনভয়েস', 'ক্লায়েন্ট', 'আরও']),
      language: 'bn',
      textScale: 2,
      surface: const Size(360, 740),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the dock hugs its items and switches without overflow', (
    tester,
  ) async {
    await tester.pumpApp(bar(), surface: const Size(411, 800));
    final create = tester.getRect(find.byTooltip('New invoice'));
    final more = tester.getRect(find.byTooltip('More'));
    final home = tester.getRect(find.text('Home'));
    // No empty stretch before the create button, and the pill hugs its
    // label instead of filling the screen.
    expect(create.left - more.right, lessThan(12));
    final invoices = tester.getRect(find.byTooltip('Invoices'));
    expect(invoices.left - home.right, lessThan(40));

    await tester.pumpApp(
      bar(index: 3),
      surface: const Size(411, 800),
      settle: false,
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 30));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('the dock keeps its width and place when the tab changes', (
    tester,
  ) async {
    Future<Rect> dockAt(int index) async {
      await tester.pumpApp(bar(index: index), surface: const Size(411, 800));
      return tester.getRect(
        find
            .descendant(
              of: find.byType(AppNavBar),
              matching: find.byType(Container),
            )
            .first,
      );
    }

    final home = await dockAt(0);
    final clients = await dockAt(2);
    final more = await dockAt(3);
    expect(clients, home);
    expect(more, home);
  });
}
