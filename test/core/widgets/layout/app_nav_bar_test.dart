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
}
