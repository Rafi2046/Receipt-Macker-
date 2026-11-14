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
import 'package:receipt_maker/features/clients/domain/models/client.dart';
import 'package:receipt_maker/features/clients/presentation/views/client_list_view.dart';
import 'package:receipt_maker/features/clients/providers.dart';
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
        path: '/clients/new',
        name: RouteNames.clientNew,
        builder: (_, _) => const Text('New Client Screen'),
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
  late MockClientRepository repo;

  setUp(() => repo = MockClientRepository());

  List<Client> makeClients(int count) => List.generate(
    count,
    (i) => testClient(id: 'client_$i', name: 'Client $i'),
  );

  testWidgets('shows limit prompt dialog when free user reaches 10 clients', (
    tester,
  ) async {
    final clients = makeClients(AppConstants.freeClientLimit);
    when(() => repo.watchAll(query: any(named: 'query')))
        .thenAnswer((_) => Stream.value(clients));

    await tester.pumpWidget(
      _buildApp(
        child: const ClientListView(),
        overrides: [
          clientRepositoryProvider.overrideWithValue(repo),
          proStatusProvider.overrideWith(() => FakeProStatus(false)),
        ],
      ),
    );
    await tester.pumpAndSettle();

    // Tap the + FAB to add another client
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify limit dialog is shown
    expect(find.byType(ConfirmDialog), findsOneWidget);
    expect(find.text('Client Limit Reached'), findsOneWidget);
    expect(
      find.text(
        'You have reached the free limit of 10 clients. Upgrade to QuickBill Pro for unlimited clients and items.',
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

  testWidgets('pro user can add client beyond 10 without dialog', (
    tester,
  ) async {
    final clients = makeClients(AppConstants.freeClientLimit);
    when(() => repo.watchAll(query: any(named: 'query')))
        .thenAnswer((_) => Stream.value(clients));

    await tester.pumpWidget(
      _buildApp(
        child: const ClientListView(),
        overrides: [
          clientRepositoryProvider.overrideWithValue(repo),
          proStatusProvider.overrideWith(() => FakeProStatus(true)),
        ],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // No limit dialog shown, directly on New Client screen
    expect(find.byType(ConfirmDialog), findsNothing);
    expect(find.text('New Client Screen'), findsOneWidget);
  });
}
