import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/constants/app_sizes.dart';
import 'package:receipt_maker/core/widgets/inputs/app_switch.dart';

import '../../../helpers/pump_app.dart';

void main() {
  testWidgets('tapping flips the value; the track is the compact size', (
    tester,
  ) async {
    bool? changed;
    await tester.pumpApp(
      Scaffold(
        body: Center(
          child: AppSwitch(value: false, onChanged: (v) => changed = v),
        ),
      ),
    );
    final track = find.descendant(
      of: find.byType(AppSwitch),
      matching: find.byType(AnimatedContainer),
    );
    expect(
      tester.getSize(track),
      const Size(AppSizes.switchWidth, AppSizes.switchHeight),
    );
    await tester.tap(find.byType(AppSwitch));
    expect(changed, isTrue);
  });

  testWidgets('a disabled switch ignores taps', (tester) async {
    await tester.pumpApp(
      const Scaffold(
        body: Center(child: AppSwitch(value: true, onChanged: null)),
      ),
    );
    await tester.tap(find.byType(AppSwitch));
    expect(tester.takeException(), isNull);
  });
}
