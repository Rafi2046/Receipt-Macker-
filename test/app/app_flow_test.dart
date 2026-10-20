import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/features/business_profile/data/mappers/business_profile_mapper.dart';
import 'package:receipt_maker/features/business_profile/domain/models/business_profile.dart';

import '../helpers/app_harness.dart';
import '../helpers/fake_app_preferences.dart';
import '../helpers/test_env.dart';

void main() {
  setUpAll(initializeDateFormatting);

  late TestEnv env;

  Future<void> pumpApp(WidgetTester tester) => tester.pumpFullApp(env);

  Future<void> tearDownApp(WidgetTester tester) => tester.tearDownFullApp(env);

  testWidgets('first run: onboarding in Bangla ends on home', (tester) async {
    env = TestEnv();
    await pumpApp(tester);
    expect(find.text('Choose your language'), findsOneWidget);

    await tester.tap(find.text('বাংলা'));
    await settle(tester);
    expect(find.text('আপনার ভাষা বেছে নিন'), findsOneWidget);
    expect(find.text('ধাপ ১/৩'), findsOneWidget);

    await tester.tap(find.text('এগিয়ে যান'));
    await settle(tester);
    await tester.tap(find.text('এগিয়ে যান'));
    await settle(tester);
    expect(
      find.text('এই ঘরটি পূরণ করুন'),
      findsOneWidget,
      reason: 'name is required',
    );

    await tester.enterText(find.byType(TextField).first, 'রহমান ট্রেডার্স');
    await tester.tap(find.text('এগিয়ে যান'));
    await settle(tester);
    expect(find.text('লোগো ও স্বাক্ষর'), findsOneWidget);

    await tester.tap(find.text('এখন নয়'));
    await settle(tester);
    expect(
      find.text('রহমান ট্রেডার্স'),
      findsOneWidget,
      reason: 'home shows the business',
    );
    expect(env.prefs.onboardingComplete, isTrue);
    expect(env.prefs.languageCode, 'bn');
    await tearDownApp(tester);
  });

  testWidgets('returning user goes straight home and can edit the profile', (
    tester,
  ) async {
    env = TestEnv(prefs: FakeAppPreferences(onboardingComplete: true));
    final t = DateTime.utc(2026, 10, 20);
    await tester.runAsync(
      () => env.db.businessProfileDao.upsert(
        BusinessProfile(
          id: 'p',
          name: 'Rahman Traders',
          createdAt: t,
          updatedAt: t,
        ).toRow(),
      ),
    );
    await pumpApp(tester);
    expect(find.text('Rahman Traders'), findsOneWidget);

    await tester.tap(find.text('Edit business profile'));
    await settle(tester);
    expect(find.text('Business profile'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Rahman Traders'),
      'Rahman & Sons',
    );
    await tester.pump();
    await tester.pageBack();
    await settle(tester);
    expect(
      find.text('Discard changes?'),
      findsOneWidget,
      reason: 'unsaved edits are guarded',
    );
    await tester.tap(find.text('Cancel'));
    await settle(tester);

    await tester.tap(find.text('Save'));
    await settle(tester);
    expect(find.text('Business profile saved'), findsOneWidget);
    await tester.pageBack();
    await settle(tester);
    expect(find.text('Rahman & Sons'), findsOneWidget);
    await tearDownApp(tester);
  });

  testWidgets('onboarding fits at 2x font in Bangla', (tester) async {
    env = TestEnv(prefs: FakeAppPreferences(languageCode: 'bn'));
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await pumpApp(tester);
    Future<void> next() async {
      await tester.tap(find.text('এগিয়ে যান'));
      await settle(tester);
    }

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -800));
    await next();
    await tester.enterText(find.byType(TextField).first, 'রহমান ট্রেডার্স');
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -1600));
    await settle(tester);
    await next();
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -800));
    await settle(tester);
    expect(find.text('এখন নয়'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tearDownApp(tester);
  });
}
