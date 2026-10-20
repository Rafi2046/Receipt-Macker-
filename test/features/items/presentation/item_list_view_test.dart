import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/features/items/presentation/views/item_list_view.dart';
import 'package:receipt_maker/features/items/providers.dart';

import '../../../helpers/mock_repositories.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late MockItemRepository repo;

  setUp(() => repo = MockItemRepository());

  Future<void> pump(
    WidgetTester tester, {
    String language = 'en',
    double textScale = 1,
  }) => tester.pumpApp(
    const ItemListView(),
    language: language,
    textScale: textScale,
    surface: const Size(360, 740),
    overrides: [itemRepositoryProvider.overrideWithValue(repo)],
  );

  testWidgets('empty offers to add the first item', (tester) async {
    when(() => repo.watchAll()).thenAnswer((_) => Stream.value([]));
    await pump(tester);
    expect(find.text('No items yet'), findsOneWidget);
    expect(find.text('Add your first item'), findsOneWidget);
  });

  testWidgets('shows price, unit and tax in the UI language', (tester) async {
    when(() => repo.watchAll()).thenAnswer(
      (_) => Stream.value([
        testItem(price: 150050)
            .copyWith(unit: 'ঘণ্টা', defaultTaxBasisPoints: 750),
        testItem(id: 'i2', name: 'Sushi', price: 1500, currency: 'JPY'),
      ]),
    );
    await pump(tester, language: 'bn');
    expect(find.text('৳১,৫০০.৫০'), findsOneWidget);
    expect(find.text('ঘণ্টা'), findsOneWidget);
    expect(find.text('ট্যাক্স ৭.৫%'), findsOneWidget);
    expect(find.text('¥১,৫০০'), findsOneWidget, reason: 'JPY has no decimals');
  });

  testWidgets('fits at 2x font in Bangla', (tester) async {
    when(() => repo.watchAll()).thenAnswer(
      (_) => Stream.value([
        testItem(
          name: 'ওয়েবসাইট ডিজাইন ও ডেভেলপমেন্ট প্যাকেজ (প্রিমিয়াম)',
          price: 99999999900,
        ).copyWith(
          description: 'পাঁচ পাতার ওয়েবসাইট, এক বছরের হোস্টিং সহ',
          unit: 'প্যাকেজ',
          defaultTaxBasisPoints: 1500,
        ),
      ]),
    );
    await pump(tester, language: 'bn', textScale: 2);
    expect(tester.takeException(), isNull);
  });
}
