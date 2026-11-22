import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/widgets/layout/app_nav_bar.dart';
import 'package:receipt_maker/core/widgets/layout/nav_bar_create_button.dart';
import 'package:receipt_maker/core/widgets/layout/nav_bar_tab.dart';

import '../../../helpers/pump_app.dart';

void main() {
  const labels = ['Home', 'Invoices', 'Estimates', 'Settings'];

  Widget bar({
    int index = 0,
    List<String> tabs = labels,
    ValueChanged<int>? onSelected,
    VoidCallback? onCreate,
  }) => Align(
    alignment: Alignment.bottomCenter,
    child: AppNavBar(
      index: index,
      labels: tabs,
      createLabel: 'Create new',
      onSelected: onSelected ?? (_) {},
      onCreate: onCreate ?? () {},
    ),
  );

  testWidgets('every tab shows its label', (tester) async {
    await tester.pumpApp(bar(index: 1));
    for (final label in labels) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.byType(NavBarTab), findsNWidgets(4));
  });

  testWidgets('create sits in the middle, two tabs on each side', (
    tester,
  ) async {
    await tester.pumpApp(bar(), surface: const Size(411, 800));
    final create = tester.getCenter(find.byType(NavBarCreateButton)).dx;
    expect(tester.getCenter(find.text('Invoices')).dx, lessThan(create));
    expect(tester.getCenter(find.text('Estimates')).dx, greaterThan(create));
    expect(create, closeTo(411 / 2, 4));
  });

  testWidgets('tapping a tab and the create button calls back', (tester) async {
    int? selected;
    var created = false;
    await tester.pumpApp(
      bar(onSelected: (i) => selected = i, onCreate: () => created = true),
    );
    await tester.tap(find.bySemanticsLabel('Settings'));
    await tester.tap(find.byTooltip('Create new'));
    expect(selected, 3);
    expect(created, isTrue);
  });

  testWidgets('Bangla labels fit on a narrow phone at 2x', (tester) async {
    await tester.pumpApp(
      bar(index: 2, tabs: const ['হোম', 'ইনভয়েস', 'কোটেশন', 'সেটিংস']),
      language: 'bn',
      textScale: 2,
      surface: const Size(360, 740),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('the dock keeps its place when the tab changes', (tester) async {
    Future<Rect> dockAt(int index) async {
      await tester.pumpApp(bar(index: index), surface: const Size(411, 800));
      return tester.getRect(find.byType(AppNavBar));
    }

    final home = await dockAt(0);
    expect(await dockAt(2), home);
    expect(await dockAt(3), home);
  });
}
