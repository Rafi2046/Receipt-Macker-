import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/ads/ad_providers.dart';
import 'package:receipt_maker/core/services/ads/rewarded_ad_presenter.dart';
import 'package:receipt_maker/core/services/pdf/brand_swatch.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/purchases/purchase_providers.dart';
import 'package:receipt_maker/core/widgets/pdf/accent_color_row.dart';

import '../../../helpers/fake_pro_status.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late List<String> picked;

  Future<void> pump(
    WidgetTester tester, {
    String? selected,
    String? logo,
    bool pro = true,
    bool adRewards = false,
  }) {
    picked = [];
    return tester.pumpApp(
      Scaffold(
        body: AccentColorRow(
          selectedHex: selected,
          template: PdfTemplate.values.first,
          logoHex: logo,
          onSelected: picked.add,
        ),
      ),
      overrides: [
        proStatusProvider.overrideWith(() => FakeProStatus(pro)),
        rewardedAdPresenterProvider.overrideWithValue(
          NoopRewardedAdPresenter(rewards: adRewards),
        ),
      ],
    );
  }

  Future<void> typeCustom(WidgetTester tester, String hex) async {
    await tester.enterText(find.byType(TextField), hex);
    await tester.pump();
    await tester.tap(find.text('Use this color'));
    await tester.pumpAndSettle();
  }

  testWidgets('a swatch is free for everyone', (tester) async {
    await pump(tester, pro: false);
    await tester.tap(find.bySemanticsLabel('Navy'));
    expect(picked, [BrandSwatch.navy.hex]);
  });

  testWidgets('Pro picks the logo color directly', (tester) async {
    await pump(tester, logo: '#1E6FD9');
    await tester.tap(find.bySemanticsLabel('Logo color'));
    await tester.pumpAndSettle();
    expect(picked, ['#1E6FD9']);
  });

  testWidgets('Pro types a custom hex code', (tester) async {
    await pump(tester);
    await tester.tap(find.bySemanticsLabel('Custom color'));
    await tester.pumpAndSettle();
    await typeCustom(tester, '#12AB34');
    expect(picked, ['#12AB34']);
  });

  testWidgets('a bad hex code shows an error and blocks saving', (
    tester,
  ) async {
    await pump(tester);
    await tester.tap(find.bySemanticsLabel('Custom color'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'nope');
    await tester.pump();
    expect(find.text('Enter a color code like #1E6FD9'), findsOneWidget);
    await tester.tap(find.text('Use this color'));
    await tester.pumpAndSettle();
    expect(picked, isEmpty);
  });

  testWidgets('free user unlocks one custom color with an ad', (tester) async {
    await pump(tester, pro: false, adRewards: true);
    await tester.tap(find.bySemanticsLabel('Custom color'));
    await tester.pumpAndSettle();
    expect(find.text('Custom colors are Pro'), findsOneWidget);
    await tester.tap(find.text('Watch an ad · use once'));
    await tester.pumpAndSettle();
    await typeCustom(tester, '#12AB34');
    expect(picked, ['#12AB34']);
  });

  testWidgets('no ad keeps the color locked and says why', (tester) async {
    await pump(tester, pro: false, logo: '#1E6FD9');
    await tester.tap(find.bySemanticsLabel('Logo color'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Watch an ad · use once'));
    await tester.pumpAndSettle();
    expect(
      find.text('No ad is ready right now. Try again in a moment, or go Pro.'),
      findsOneWidget,
    );
    expect(picked, isEmpty);
  });
}
