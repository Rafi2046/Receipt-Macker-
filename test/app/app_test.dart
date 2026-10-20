import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/app/app.dart';
import 'package:receipt_maker/app/theme/app_colors.dart';

void main() {
  setUpAll(initializeDateFormatting);

  testWidgets('starts on the theme preview in English', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.text('Theme preview'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Paid'), 200);
    expect(find.text('Paid'), findsOneWidget);
  });

  testWidgets('switches to Bangla and dark mode', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('বাংলা'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ডার্ক'));
    await tester.pumpAndSettle();

    expect(find.text('থিম প্রিভিউ'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('পরিশোধিত'), 200);
    expect(find.text('পরিশোধিত'), findsOneWidget);
    final context = tester.element(find.byType(Scaffold));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(context.appColors.surface, isNot(const Color(0xFFFFFFFF)));
  });
}
