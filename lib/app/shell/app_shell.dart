import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/ads/list_ad_banner.dart';
import '../../core/utils/extensions/l10n_extension.dart';
import '../../core/widgets/layout/app_nav_bar.dart';
import '../router/route_names.dart';
import 'create_choice_sheet.dart';

/// The four tabs that stay on screen: Home, Invoices, Estimates, Settings,
/// with the create button between them. Nested screens cover the bar.
class AppShell extends StatelessWidget {
  const AppShell({required this.shell, required this.path, super.key});

  final StatefulNavigationShell shell;

  /// Current location. The tab bar shows only on the tab roots.
  final String path;

  static bool showsTabBar(String path) =>
      path == RouteNames.homePath ||
      path == RouteNames.invoicesPath ||
      path == RouteNames.quotesPath ||
      path == RouteNames.settingsPath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      // Pages show their own snackbars. Without this messenger the shell
      // scaffold would draw them over a Save bar.
      body: Column(
        children: [
          Expanded(child: ScaffoldMessenger(child: shell)),
          if (path == RouteNames.invoicesPath || path == RouteNames.quotesPath)
            const ListAdBanner(),
          if (showsTabBar(path))
            AppNavBar(
              index: shell.currentIndex,
              labels: [
                l10n.navHome,
                l10n.invoicesTitle,
                l10n.quotesTitle,
                l10n.settingsTitle,
              ],
              createLabel: l10n.createChooseTitle,
              onSelected: (index) => shell.goBranch(
                index,
                initialLocation: index == shell.currentIndex,
              ),
              onCreate: () => CreateChoiceSheet.show(context),
            ),
        ],
      ),
    );
  }
}
