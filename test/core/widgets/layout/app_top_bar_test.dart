import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/widgets/layout/app_scaffold.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('a tab title has no back button', (tester) async {
    await tester.pumpApp(
      const AppScaffold(title: 'More', body: SizedBox.shrink()),
    );
    expect(find.text('More'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
  });

  testWidgets(
    'a pushed screen shows a round Back button beside a centered title',
    (tester) async {
      await tester.pumpApp(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const AppScaffold(
                  title: 'Privacy policy',
                  body: SizedBox.shrink(),
                ),
              ),
            ),
            child: const Text('Open'),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Privacy policy'), findsOneWidget);
      final back = tester.getRect(find.byTooltip('Back'));
      final title = tester.getCenter(find.text('Privacy policy'));
      expect(title.dy, inInclusiveRange(back.top, back.bottom));
      expect(title.dx, greaterThan(back.right));
    },
  );

  testWidgets('a tab title is left-aligned', (tester) async {
    await tester.pumpApp(
      const AppScaffold(title: 'More', body: SizedBox.shrink()),
      surface: const Size(360, 740),
    );
    expect(tester.getTopLeft(find.text('More')).dx, lessThan(40));
  });

  testWidgets('a long Bangla title fits at 2x', (tester) async {
    await tester.pumpApp(
      const AppScaffold(
        title: 'ওয়েবসাইট ডিজাইন ও ডেভেলপমেন্ট প্যাকেজ (প্রিমিয়াম)',
        body: SizedBox.shrink(),
      ),
      language: 'bn',
      textScale: 2,
      surface: const Size(360, 740),
    );
    expect(tester.takeException(), isNull);
  });
}
