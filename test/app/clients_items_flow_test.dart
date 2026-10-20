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

  /// A returning user on the home screen.
  Future<void> openHome(WidgetTester tester, {String language = 'en'}) async {
    env = TestEnv(
      prefs: FakeAppPreferences(
        onboardingComplete: true,
        languageCode: language,
      ),
    );
    final t = DateTime.utc(2026, 10, 20);
    await tester.runAsync(
      () => env.db.businessProfileDao.upsert(
        BusinessProfile(
          id: 'p',
          name: 'Shop',
          createdAt: t,
          updatedAt: t,
        ).toRow(),
      ),
    );
    await tester.pumpFullApp(env);
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await settle(tester);
  }

  Finder field(String label) => find.widgetWithText(TextField, label);

  testWidgets('client: add, find, edit, delete', (tester) async {
    await openHome(tester);
    await tap(tester, find.text('Clients'));
    expect(find.text('No clients yet'), findsOneWidget);

    await tap(tester, find.text('Add your first client'));
    expect(find.text('New client'), findsOneWidget);
    await tap(tester, find.text('Save'));
    expect(find.text('This field is required'), findsOneWidget);

    await tester.enterText(field('Client name'), 'Karim Store');
    await tester.enterText(field('Phone'), '০১৭১২৩৪৫৬৭৮');
    await tap(tester, find.text('Save'));
    expect(find.text('Client saved'), findsOneWidget);
    expect(find.text('Karim Store'), findsOneWidget);
    expect(find.text('01712345678'), findsOneWidget, reason: 'stored Latin');

    await tester.enterText(find.byType(TextField), '1234');
    await settle(tester);
    expect(find.text('Karim Store'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'nobody');
    await settle(tester);
    expect(find.text('No matches'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '');
    await settle(tester);

    await tap(tester, find.text('Karim Store'));
    expect(find.text('Edit client'), findsOneWidget);
    await tester.enterText(field('Karim Store'), 'Karim & Sons');
    await tester.pump();
    await tester.pageBack();
    await settle(tester);
    expect(find.text('Discard changes?'), findsOneWidget);
    await tap(tester, find.text('Cancel'));
    await tap(tester, find.text('Save'));
    expect(find.text('Karim & Sons'), findsOneWidget);

    await tap(tester, find.text('Karim & Sons'));
    await tap(tester, find.byTooltip('Delete'));
    expect(find.text('Delete this client?'), findsOneWidget);
    await tap(tester, find.widgetWithText(FilledButton, 'Delete'));
    expect(find.text('Client deleted'), findsOneWidget);
    expect(find.text('No clients yet'), findsOneWidget);
    await tester.tearDownFullApp(env);
  });

  testWidgets('item: add with price and tax, shown in Bangla', (tester) async {
    await openHome(tester, language: 'bn');
    await tap(tester, find.text('আরও'));
    await tap(tester, find.text('পণ্য ও সেবা'));
    await tap(tester, find.text('প্রথম পণ্য বা সেবা যোগ করুন'));

    await tester.enterText(field('নাম'), 'লোগো ডিজাইন');
    await tap(tester, find.text('সংরক্ষণ করুন'));
    expect(find.text('এই ঘরটি পূরণ করুন'), findsOneWidget, reason: 'price');

    await tester.enterText(field('একক মূল্য'), '১৫০০.৫');
    await tester.enterText(field('একক'), 'পিস');
    await tester.enterText(field('ডিফল্ট ট্যাক্স'), '15');
    await tap(tester, find.text('সংরক্ষণ করুন'));
    expect(find.text('লোগো ডিজাইন'), findsOneWidget);
    expect(find.text('৳১,৫০০.৫০'), findsOneWidget);
    expect(find.text('ট্যাক্স ১৫%'), findsOneWidget);

    final saved = await tester.runAsync(
      () => env.db.select(env.db.itemsTable).getSingle(),
    );
    expect(saved?.unitPriceMinor, 150050);
    expect(saved?.currencyCode, 'BDT');
    expect(saved?.defaultTaxBasisPoints, 1500);
    await tester.tearDownFullApp(env);
  });

  testWidgets('editors fit at 2x font in Bangla', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openHome(tester, language: 'bn');

    await tap(tester, find.text('ক্লায়েন্ট'));
    await tap(tester, find.text('প্রথম ক্লায়েন্ট যোগ করুন'));
    await tap(tester, find.text('সংরক্ষণ করুন'));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await settle(tester);
    expect(tester.takeException(), isNull);
    Navigator.of(tester.element(find.byType(Scrollable).first)).pop();
    await settle(tester);

    await tap(tester, find.text('আরও'));
    await tap(tester, find.text('পণ্য ও সেবা'));
    await tap(tester, find.text('প্রথম পণ্য বা সেবা যোগ করুন'));
    await tap(tester, find.text('সংরক্ষণ করুন'));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await tester.tearDownFullApp(env);
  });
}
