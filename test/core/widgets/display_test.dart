import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/app/theme/app_colors.dart';
import 'package:receipt_maker/core/widgets/display/amount_text.dart';
import 'package:receipt_maker/core/widgets/display/avatar_initials.dart';
import 'package:receipt_maker/core/widgets/display/status_chip.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AmountText uses Bangla digits in Bangla', (tester) async {
    await tester.pumpApp(
      const AmountText(minor: 12345678, currencyCode: 'BDT'),
      language: 'bn',
    );
    expect(find.text('৳১,২৩,৪৫৬.৭৮'), findsOneWidget);
  });

  testWidgets('AmountText uses Latin digits in English', (tester) async {
    await tester.pumpApp(
      const AmountText(minor: 12345678, currencyCode: 'BDT'),
    );
    expect(find.text('৳123,456.78'), findsOneWidget);
  });

  testWidgets('StatusChip shows its label in the tone color', (tester) async {
    await tester.pumpApp(
      const StatusChip(label: 'Overdue', tone: StatusTone.danger),
      themeMode: ThemeMode.dark,
    );
    final text = tester.widget<Text>(find.text('Overdue'));
    final context = tester.element(find.text('Overdue'));
    expect(text.style?.color, context.appColors.danger);
  });

  testWidgets('AvatarInitials is decorative unless labelled', (tester) async {
    await tester.pumpApp(const AvatarInitials(name: 'রহিম উদ্দিন'));
    expect(find.text('রউ'), findsOneWidget);
    expect(find.bySemanticsLabel('রউ'), findsNothing);

    await tester.pumpApp(
      const AvatarInitials(name: 'রহিম উদ্দিন', semanticLabel: 'রহিম উদ্দিন'),
    );
    expect(find.bySemanticsLabel('রহিম উদ্দিন'), findsOneWidget);
  });
}
