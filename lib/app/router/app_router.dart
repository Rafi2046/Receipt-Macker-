import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/debug/presentation/views/theme_preview_view.dart';
import '../../features/debug/presentation/views/widget_gallery_view.dart';
import 'route_names.dart';

part 'app_router.g.dart';

// TODO(M2): start at onboarding / dashboard; move the preview under a debug-only route.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: RouteNames.themePreviewPath,
  routes: [
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
  ],
);
