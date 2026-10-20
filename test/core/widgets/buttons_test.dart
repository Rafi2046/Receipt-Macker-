import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/constants/app_icons.dart';
import 'package:receipt_maker/core/widgets/buttons/app_button.dart';
import 'package:receipt_maker/core/widgets/buttons/app_icon_button.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('AppButton calls onPressed', (tester) async {
    var taps = 0;
    await tester.pumpApp(AppButton(label: 'Save', onPressed: () => taps++));
    await tester.tap(find.text('Save'));
    expect(taps, 1);
  });

  testWidgets('AppButton ignores taps and shows a spinner while loading', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(
      AppButton(label: 'Save', isLoading: true, onPressed: () => taps++),
      settle: false,
    );
    await tester.tap(find.text('Save'));
    expect(taps, 0);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('AppButton with null onPressed is disabled', (tester) async {
    await tester.pumpApp(const AppButton(label: 'Save', onPressed: null));
    final button = tester.widget<ButtonStyleButton>(
      find.byWidgetPredicate((w) => w is ButtonStyleButton),
    );
    expect(button.enabled, isFalse);
  });

  testWidgets('AppIconButton exposes its label and a 48dp target', (
    tester,
  ) async {
    await tester.pumpApp(
      AppIconButton(
        icon: AppIcons.share,
        semanticLabel: 'Share invoice',
        onPressed: () {},
      ),
    );
    expect(find.byTooltip('Share invoice'), findsOneWidget);
    final size = tester.getSize(find.byType(IconButton));
    expect(size.width, greaterThanOrEqualTo(48));
    expect(size.height, greaterThanOrEqualTo(48));
  });
}
