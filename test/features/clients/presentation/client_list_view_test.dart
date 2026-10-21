import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/core/errors/failure.dart';
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/clients/presentation/views/client_list_view.dart';
import 'package:receipt_maker/features/clients/providers.dart';

import '../../../helpers/mock_repositories.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late MockClientRepository repo;

  setUp(() => repo = MockClientRepository());

  Future<void> pump(
    WidgetTester tester, {
    String language = 'en',
    double textScale = 1,
    bool settle = true,
  }) => tester.pumpApp(
    const ClientListView(),
    language: language,
    textScale: textScale,
    surface: const Size(360, 740),
    settle: settle,
    overrides: [clientRepositoryProvider.overrideWithValue(repo)],
  );

  void stub(Stream<List<Client>> Function(String query) answer) =>
      when(() => repo.watchAll(query: any(named: 'query')))
          .thenAnswer((i) => answer(i.namedArguments[#query] as String));

  testWidgets('loading shows a spinner', (tester) async {
    final never = StreamController<List<Client>>();
    addTearDown(never.close);
    stub((_) => never.stream);
    await pump(tester, settle: false);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('empty offers to add the first client, no search box', (
    tester,
  ) async {
    stub((_) => Stream.value([]));
    await pump(tester);
    expect(find.text('No clients yet'), findsOneWidget);
    expect(find.text('Add your first client'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('error shows a message and Retry', (tester) async {
    stub((_) => Stream.error(const DatabaseFailure()));
    await pump(tester);
    expect(find.text("Couldn't read or save your data. Try again."), findsOne);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('lists clients and searches as you type', (tester) async {
    stub(
      (q) => Stream.value(
        q.isEmpty
            ? [
                testClient(name: 'Karim').copyWith(phone: '01712345678'),
                testClient(id: 'c2', name: 'Rahman & Sons'),
              ]
            : [],
      ),
    );
    await pump(tester, language: 'bn');
    expect(find.text('Karim'), findsOneWidget);
    expect(find.text('০১৭১২৩৪৫৬৭৮'), findsOneWidget, reason: 'Bangla digits');
    expect(find.byType(FloatingActionButton), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zz');
    await tester.pumpAndSettle();
    expect(find.text('কিছু পাওয়া যায়নি'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget, reason: 'search stays');

    await tester.tap(find.byTooltip('খোঁজা মুছুন'));
    await tester.pumpAndSettle();
    expect(find.text('Karim'), findsOneWidget);
  });

  testWidgets('fits at 2x font in Bangla', (tester) async {
    stub(
      (_) => Stream.value([
        testClient(
          name: 'মেসার্স রহমান অ্যান্ড সন্স জেনারেল ট্রেডিং কোম্পানি লিমিটেড',
        ).copyWith(phone: '01712345678', email: 'very.long.name@example.com'),
      ]),
    );
    await pump(tester, language: 'bn', textScale: 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a card lines contacts up under the name', (tester) async {
    stub(
      (_) => Stream.value([
        testClient(name: 'Karim')
            .copyWith(phone: '01712345678', email: 'karim@example.com'),
      ]),
    );
    await pump(tester);
    final name = tester.getRect(find.text('Karim'));
    final phone = tester.getRect(find.byIcon(Icons.phone_outlined));
    final email = tester.getRect(find.byIcon(Icons.email_outlined));
    final card = tester.getRect(find.byType(Card));
    final chevron = tester.getRect(find.byIcon(Icons.chevron_right));
    expect(phone.left, name.left);
    expect(email.left, name.left);
    expect(phone.top, greaterThan(name.bottom));
    expect(email.top, greaterThan(phone.bottom));
    expect(chevron.center.dy, closeTo(card.center.dy, 1));
  });
}
