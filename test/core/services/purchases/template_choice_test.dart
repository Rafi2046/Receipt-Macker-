import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_maker/core/services/pdf/pdf_template.dart';
import 'package:receipt_maker/core/services/purchases/free_plan.dart';
import 'package:receipt_maker/core/services/purchases/template_choice.dart';

import '../../../helpers/fake_app_preferences.dart';

void main() {
  final pro = PdfTemplate.values.firstWhere((t) => t.requiresPro);
  final otherPro = PdfTemplate.values.lastWhere((t) => t.requiresPro);
  final free = PdfTemplate.values.firstWhere((t) => !t.requiresPro);

  test('ten designs are free and the gallery holds hundreds', () {
    expect(FreePlan.freeDesignCount, 10);
    expect(FreePlan.designCount, greaterThan(300));
  });

  test('a free user may use only the Pro template opened with an ad', () {
    expect(FreePlan.canUse(pro, isPro: false), isFalse);
    expect(FreePlan.canUse(pro, isPro: false, adUnlockedId: pro.id), isTrue);
    expect(
      FreePlan.canUse(otherPro, isPro: false, adUnlockedId: pro.id),
      isFalse,
    );
    expect(FreePlan.canUse(free, isPro: false), isTrue);
    expect(FreePlan.canUse(pro, isPro: true), isTrue);
  });

  test('the ad unlock lasts until another template is chosen', () async {
    final prefs = FakeAppPreferences();
    await TemplateChoice.unlockWithAd(prefs, pro);
    await TemplateChoice.remember(prefs, pro);
    expect(prefs.pdfTemplate, pro.id);
    expect(prefs.adUnlockedTemplate, pro.id, reason: 'still on it');

    await TemplateChoice.remember(prefs, free);
    expect(prefs.pdfTemplate, free.id);
    expect(prefs.adUnlockedTemplate, isNull, reason: 'used once');
  });
}
