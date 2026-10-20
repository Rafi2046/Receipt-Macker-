import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_icons.dart';
import '../../core/utils/extensions/l10n_extension.dart';
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
      body: shell,
      bottomNavigationBar: show
          ? NavigationBar(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: (index) => shell.goBranch(
                index,
                initialLocation: index == shell.currentIndex,
              ),
              destinations: [
                NavigationDestination(
                  icon: const Icon(AppIcons.dashboard),
                  label: l10n.navHome,
                ),
                NavigationDestination(
                  icon: const Icon(AppIcons.invoice),
                  label: l10n.invoicesTitle,
                ),
                NavigationDestination(
                  icon: const Icon(AppIcons.client),
                  label: l10n.clientsTitle,
                ),
                NavigationDestination(
                  icon: const Icon(AppIcons.more),
                  label: l10n.navMore,
                ),
              ],
            )
          : null,
    );
  }
}
