import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/ads/list_ad_banner.dart';
import '../../core/utils/extensions/l10n_extension.dart';
import '../../core/widgets/layout/app_menu_host.dart';
import '../../core/widgets/layout/app_nav_bar.dart';
import '../../features/dashboard/presentation/widgets/app_menu_drawer.dart';
import '../router/route_names.dart';
import 'create_choice_sheet.dart';

/// Opens the shell side menu from nested tab screens.
final GlobalKey<ScaffoldState> appShellScaffoldKey = GlobalKey<ScaffoldState>();

void openAppMenuDrawer() => appShellScaffoldKey.currentState?.openDrawer();

/// The tabs that stay on screen: Home, Invoices, Estimates, Clients, More.
/// Nested screens (an invoice, an editor) cover the bar.
class AppShell extends StatelessWidget {
  const AppShell({required this.shell, required this.path, super.key});

  final StatefulNavigationShell shell;

  /// Current location. The tab bar shows only on the tab roots.
  final String path;

  static bool showsTabBar(String path) =>
      path == RouteNames.homePath ||
      path == RouteNames.invoicesPath ||
      path == RouteNames.quotesPath ||
      path == RouteNames.clientsPath ||
      path == RouteNames.morePath;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final show = showsTabBar(path);
    return AppMenuHost(
      openMenu: openAppMenuDrawer,
      child: Scaffold(
        key: appShellScaffoldKey,
        drawer: const AppMenuDrawer(),
        // Pages show their own snackbars. Without this messenger the shell
        // scaffold would draw them over a Save bar.
        body: Column(
          children: [
            Expanded(child: ScaffoldMessenger(child: shell)),
            if (path == RouteNames.invoicesPath ||
                path == RouteNames.quotesPath ||
                path == RouteNames.clientsPath)
              const ListAdBanner(),
            if (show)
              AppNavBar(
                index: shell.currentIndex,
                labels: [
                  l10n.navHome,
                  l10n.invoicesTitle,
                  l10n.quotesTitle,
                  l10n.clientsTitle,
                  l10n.navMore,
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
      ),
    );
  }
}
