import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/ads/list_ad_banner.dart';
import '../../core/utils/extensions/l10n_extension.dart';
import '../../core/widgets/layout/app_nav_bar.dart';
import '../router/route_names.dart';

/// The four tabs that stay on screen: Home, Invoices, Clients, More.
/// Nested screens (an invoice, an editor) cover the bar.
class AppShell extends StatelessWidget {
  const AppShell({required this.shell, required this.path, super.key});

  final StatefulNavigationShell shell;

  /// Current location. The tab bar shows only on the four tab roots.
  final String path;

  static bool showsTabBar(String path) =>
      path == RouteNames.homePath ||
      path == RouteNames.invoicesPath ||
      path == RouteNames.clientsPath ||
      path == RouteNames.morePath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final show = showsTabBar(path);
    return Scaffold(
      // Pages show their own snackbars. Without this messenger the shell
      // scaffold would draw them over a Save bar.
      body: Column(
        children: [
          Expanded(child: ScaffoldMessenger(child: shell)),
          if (path == RouteNames.invoicesPath || path == RouteNames.clientsPath)
            const ListAdBanner(),
          if (show)
            AppNavBar(
              index: shell.currentIndex,
              labels: [
                l10n.navHome,
                l10n.invoicesTitle,
                l10n.clientsTitle,
                l10n.navMore,
              ],
              createLabel: l10n.invoiceNewTitle,
              onSelected: (index) => shell.goBranch(
                index,
                initialLocation: index == shell.currentIndex,
              ),
              onCreate: () => context.pushNamed(RouteNames.invoiceNew),
            ),
        ],
      ),
    );
  }
}
