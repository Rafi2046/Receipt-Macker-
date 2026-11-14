import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:receipt_maker/app/router/route_names.dart';
import 'package:receipt_maker/app/theme/app_theme.dart';
import 'package:receipt_maker/core/constants/app_constants.dart';
import 'package:receipt_maker/core/services/purchases/purchase_providers.dart';
import 'package:receipt_maker/core/widgets/feedback/confirm_dialog.dart';
import 'package:receipt_maker/features/items/domain/models/item.dart';
import 'package:receipt_maker/features/items/presentation/views/item_list_view.dart';
import 'package:receipt_maker/features/items/providers.dart';
import 'package:receipt_maker/l10n/gen/app_localizations.dart';

import '../../../helpers/mock_repositories.dart';

class FakeProStatus extends ProStatus {
  FakeProStatus(this._isPro);
  final bool _isPro;

  @override
  bool build() => _isPro;
}

Widget _buildApp({required Widget child, required List<Override> overrides}) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: child),
      ),
      GoRoute(
        path: '/items/new',
        name: RouteNames.itemNew,
        builder: (_, _) => const Text('New Item Screen'),
      ),
      GoRoute(
        path: '/paywall',
        name: RouteNames.paywall,
        builder: (_, _) => const Text('Paywall Screen'),
      ),
    ],
  );

  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      theme: AppTheme.light(),
      locale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    ),
  );
}

void main() {
  late MockItemRepository repo;

  setUp(() => repo = MockItemRepository());

  List<Item> makeItems(int count) =>
      List.generate(count, (i) => testItem(id: 'item_$i', name: 'Item $i'));

  testWidgets('shows limit prompt dialog when free user reaches 20 items', (
    tester,
  ) async {
    final items = makeItems(AppConstants.freeItemLimit);
    when(() => repo.watchAll(query: any(named: 'query')))
        .thenAnswer((_) => Stream.value(items));

    await tester.pumpWidget(
      _buildApp(
        child: const ItemListView(),
        overrides: [
          itemRepositoryProvider.overrideWithValue(repo),
          proStatusProvider.overrideWith(() => FakeProStatus(false)),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Tap the + FAB to add another item
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify limit dialog is shown
    expect(find.byType(ConfirmDialog), findsOneWidget);
    expect(find.text('Item Limit Reached'), findsOneWidget);
    expect(
      find.text(
        'You have reached the free limit of 20 items. Upgrade to QuickBill Pro for unlimited clients and items.',
      ),
      findsOneWidget,
    );
    expect(find.text('Upgrade to Pro'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // Tapping Upgrade to Pro navigates to Paywall
    await tester.tap(find.text('Upgrade to Pro'));
    await tester.pumpAndSettle();
    expect(find.text('Paywall Screen'), findsOneWidget);
  });

  testWidgets('pro user can add item beyond 20 without dialog', (tester) async {
    final items = makeItems(AppConstants.freeItemLimit);
    when(() => repo.watchAll(query: any(named: 'query')))
        .thenAnswer((_) => Stream.value(items));

    await tester.pumpWidget(
      _buildApp(
        child: const ItemListView(),
        overrides: [
          itemRepositoryProvider.overrideWithValue(repo),
          proStatusProvider.overrideWith(() => FakeProStatus(true)),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // No limit dialog shown, directly on New Item screen
    expect(find.byType(ConfirmDialog), findsNothing);
    expect(find.text('New Item Screen'), findsOneWidget);
  });
}
