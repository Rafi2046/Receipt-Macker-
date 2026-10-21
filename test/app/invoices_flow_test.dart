import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:receipt_maker/features/business_profile/data/mappers/business_profile_mapper.dart';
import 'package:receipt_maker/features/business_profile/domain/models/business_profile.dart';
import 'package:receipt_maker/features/clients/data/mappers/client_mapper.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/items/data/mappers/item_mapper.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';

import '../helpers/app_harness.dart';
import '../helpers/fake_app_preferences.dart';
import '../helpers/test_env.dart';

void main() {
  setUpAll(initializeDateFormatting);

  late TestEnv env;
  final t = DateTime.utc(2026, 10, 20);

  /// A returning user with one client and one item, on the home screen.
  Future<void> openHome(WidgetTester tester, {String language = 'en'}) async {
    env = TestEnv(
      prefs: FakeAppPreferences(
        onboardingComplete: true,
        languageCode: language,
      ),
    );
    await tester.runAsync(() async {
      await env.db.businessProfileDao.upsert(
        BusinessProfile(
          id: 'p',
          name: 'Shop',
          createdAt: t,
          updatedAt: t,
        ).toRow(),
      );
      await env.db.clientDao.upsert(
        Client(
          id: 'c',
          name: 'Karim Store',
          createdAt: t,
          updatedAt: t,
        ).toRow(),
      );
      await env.db.itemDao.upsert(
        Item(
          id: 'i',
          name: 'Logo design',
          unitPriceMinor: 500000,
          currencyCode: 'BDT',
          defaultTaxBasisPoints: 1500,
          createdAt: t,
          updatedAt: t,
        ).toRow(),
      );
    });
    await tester.pumpFullApp(env);
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await settle(tester);
  }

  Future<void> menu(WidgetTester tester, String action) async {
    await tap(tester, find.byTooltip('More actions'));
    await tap(tester, find.text(action));
  }

  testWidgets('create, mark sent, duplicate and delete an invoice', (
    tester,
  ) async {
    await openHome(tester);
    await tap(tester, find.byTooltip('Invoices'));
    expect(find.text('No invoices yet'), findsOneWidget);

    await tap(tester, find.text('Create your first invoice'));
    expect(find.text('INV-0001'), findsOneWidget);
    await tap(tester, find.text('Save'));
    expect(find.text('Add at least one item'), findsOneWidget);

    await tap(tester, find.text('Choose a client'));
    await tap(tester, find.text('Karim Store'));
    expect(find.text('Karim Store'), findsOneWidget);

    await tap(tester, find.widgetWithText(OutlinedButton, 'Add an item'));
    await tap(tester, find.text('Logo design'));
    expect(find.text('Tax 15%'), findsOneWidget, reason: 'item default tax');
    expect(find.text('৳5,750'), findsOneWidget);

    await tap(tester, find.text('Save'));
    expect(find.text('Invoice saved'), findsOneWidget);
    expect(find.text('Draft'), findsOneWidget);
    expect(find.text('৳5,750'), findsNWidgets(2), reason: 'header, total');

    await menu(tester, 'Mark as sent');
    expect(find.text('Sent'), findsOneWidget);

    await menu(tester, 'Duplicate');
    expect(find.text('INV-0002'), findsOneWidget);
    await tap(tester, find.text('Save'));
    expect(find.text('INV-0002'), findsOneWidget);
    expect(find.text('Draft'), findsOneWidget, reason: 'a copy is a draft');

    await tester.pageBack();
    await settle(tester);
    await menu(tester, 'Delete');
    await tap(tester, find.widgetWithText(FilledButton, 'Delete'));
    expect(find.text('Invoice deleted'), findsOneWidget);
    // The list shows the number inside the "number • due date" line.
    Finder listed(String n) => find.textContaining(n, findRichText: true);
    expect(listed('INV-0002'), findsOneWidget);
    expect(listed('INV-0001'), findsNothing);
    await tester.tearDownFullApp(env);
  });

  testWidgets('leaving a new invoice with changes asks first', (tester) async {
    await openHome(tester);
    await tap(tester, find.byTooltip('Invoices'));
    await tap(tester, find.text('Create your first invoice'));
    await tap(tester, find.widgetWithText(OutlinedButton, 'Add an item'));
    await tap(tester, find.text('Logo design'));
    await tester.pageBack();
    await settle(tester);
    expect(find.text('Discard changes?'), findsOneWidget);
    await tester.tearDownFullApp(env);
  });

  testWidgets('editor and line sheet fit at 2x font in Bangla', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await openHome(tester, language: 'bn');
    await tap(tester, find.byTooltip('ইনভয়েস'));
    await tap(tester, find.text('প্রথম ইনভয়েস তৈরি করুন'));
    await tap(tester, find.text('বিল প্রাপক').first);
    await tap(
      tester,
      find.widgetWithText(OutlinedButton, 'পণ্য বা সেবা যোগ করুন'),
    );
    await tap(tester, find.text('Logo design'));
    await tap(tester, find.text('Logo design').first);
    expect(find.text('লাইন আইটেম'), findsOneWidget);
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -2000));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await tap(tester, find.text('হয়েছে'));
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -4000));
    await settle(tester);
    expect(tester.takeException(), isNull);
    await tester.tearDownFullApp(env);
  });
}
