import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/widgets/layout/app_nav_bar.dart';

import '../../../helpers/pump_app.dart';

void main() {
  Widget bar({
    int index = 0,
    List<String> labels = const [
      'Home',
      'Invoices',
      'Estimates',
      'Clients',
      'More',
    ],
    ValueChanged<int>? onSelected,
    VoidCallback? onCreate,
  }) => Align(
    alignment: Alignment.bottomCenter,
    child: AppNavBar(
      index: index,
      labels: labels,
      createLabel: 'Create new',
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
    expect(find.text('Estimates'), findsNothing);
    expect(find.text('Clients'), findsNothing);
  });

  testWidgets('tapping a tab and the create button calls back', (tester) async {
    int? selected;
    var created = false;
    await tester.pumpApp(
      bar(onSelected: (i) => selected = i, onCreate: () => created = true),
    );
    await tester.tap(find.bySemanticsLabel('Clients'));
    await tester.tap(find.byTooltip('Create new'));
    expect(selected, 3);
    expect(created, isTrue);
  });

  testWidgets('a Bangla label fits on a narrow phone at 2x', (tester) async {
    await tester.pumpApp(
      bar(
        index: 3,
        labels: const ['হোম', 'ইনভয়েস', 'কোটেশন', 'ক্লায়েন্ট', 'আরও'],
      ),
      language: 'bn',
      textScale: 2,
      surface: const Size(360, 740),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the dock spans the page and switches without overflow', (
    tester,
  ) async {
    await tester.pumpApp(bar(), surface: const Size(411, 800));
    final dock = tester.getRect(
      find
          .descendant(
            of: find.byType(AppNavBar),
            matching: find.byType(Container),
          )
          .first,
    );
    // Matches page content inset (16) on a 411-wide phone.
    expect(dock.left, closeTo(16, 1));
    expect(dock.right, closeTo(411 - 16, 1));
    expect(tester.getSize(find.text('Home')).width, greaterThan(40));

    await tester.pumpApp(
      bar(index: 4),
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
    final clients = await dockAt(3);
    final more = await dockAt(4);
    expect(clients, home);
    expect(more, home);
  });
}
