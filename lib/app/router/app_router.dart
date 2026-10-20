import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/business_profile/presentation/views/business_profile_view.dart';
import '../../features/clients/presentation/views/client_editor_view.dart';
import '../../features/clients/presentation/views/client_list_view.dart';
import '../../features/dashboard/presentation/views/home_view.dart';
import '../../features/debug/presentation/views/logo_concepts_view.dart';
import '../../features/debug/presentation/views/logo_splash_preview_view.dart';
import '../../features/debug/presentation/views/theme_preview_view.dart';
import '../../features/debug/presentation/views/widget_gallery_view.dart';
import '../../features/items/presentation/views/item_editor_view.dart';
import '../../features/items/presentation/views/item_list_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/onboarding/providers.dart';
import 'route_names.dart';

part 'app_router.g.dart';

/// Until onboarding is complete every location redirects to it; afterwards
/// onboarding redirects home. The router itself is built once.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final onboarded = ValueNotifier<bool>(ref.read(onboardingStatusProvider));
  ref
    ..listen(onboardingStatusProvider, (_, next) => onboarded.value = next)
    ..onDispose(onboarded.dispose);
  return GoRouter(
    initialLocation: RouteNames.homePath,
    refreshListenable: onboarded,
    redirect: (_, state) {
      final atOnboarding = state.matchedLocation == RouteNames.onboardingPath;
      if (!onboarded.value && !atOnboarding) return RouteNames.onboardingPath;
      if (onboarded.value && atOnboarding) return RouteNames.homePath;
      return null;
    },
    routes: [
      GoRoute(
        name: RouteNames.home,
        path: RouteNames.homePath,
        builder: (_, _) => const HomeView(),
      ),
      GoRoute(
        name: RouteNames.onboarding,
        path: RouteNames.onboardingPath,
        builder: (_, _) => const OnboardingView(),
      ),
      GoRoute(
        name: RouteNames.businessProfile,
        path: RouteNames.businessProfilePath,
        builder: (_, _) => const BusinessProfileView(),
      ),
      _clientRoutes,
      _itemRoutes,
      if (kDebugMode) ..._debugRoutes,
    ],
  );
}

// "new" is listed before ":id" so it never matches as an id.
final GoRoute _clientRoutes = GoRoute(
  name: RouteNames.clients,
  path: RouteNames.clientsPath,
  builder: (_, _) => const ClientListView(),
  routes: [
    GoRoute(
      name: RouteNames.clientNew,
      path: RouteNames.clientNewPath,
      builder: (_, _) => const ClientEditorView(),
    ),
    GoRoute(
      name: RouteNames.clientEdit,
      path: RouteNames.clientEditPath,
      builder: (_, state) =>
          ClientEditorView(clientId: state.pathParameters[RouteNames.idParam]),
    ),
  ],
);

final GoRoute _itemRoutes = GoRoute(
  name: RouteNames.items,
  path: RouteNames.itemsPath,
  builder: (_, _) => const ItemListView(),
  routes: [
    GoRoute(
      name: RouteNames.itemNew,
      path: RouteNames.itemNewPath,
      builder: (_, _) => const ItemEditorView(),
    ),
    GoRoute(
      name: RouteNames.itemEdit,
      path: RouteNames.itemEditPath,
      builder: (_, state) =>
          ItemEditorView(itemId: state.pathParameters[RouteNames.idParam]),
    ),
  ],
);

final List<GoRoute> _debugRoutes = [
  GoRoute(
    name: RouteNames.themePreview,
    path: RouteNames.themePreviewPath,
    builder: (_, _) => const ThemePreviewView(),
  ),
  GoRoute(
    name: RouteNames.widgetGallery,
    path: RouteNames.widgetGalleryPath,
    builder: (_, _) => const WidgetGalleryView(),
  ),
  GoRoute(
    name: RouteNames.logoConcepts,
    path: RouteNames.logoConceptsPath,
    builder: (_, _) => const LogoConceptsView(),
  ),
  GoRoute(
    name: RouteNames.logoSplash,
    path: RouteNames.logoSplashPath,
    builder: (_, state) {
      final query = state.uri.queryParameters;
      return LogoSplashPreviewView(
        concept: int.tryParse(query[RouteNames.conceptParam] ?? '') ?? 0,
        dark: query[RouteNames.darkParam] == 'true',
      );
    },
  ),
];
