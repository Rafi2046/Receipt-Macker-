import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'nav_bar_create_button.dart';
import 'nav_bar_tab.dart';

/// Floating pill dock, centered and as wide as its items: four tab
/// circles, the selected one stretched into a labelled pill, and a create
/// button for a new invoice at the end. Its width never changes with the
/// selection.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.index,
    required this.labels,
    required this.createLabel,
    required this.onSelected,
    required this.onCreate,
    super.key,
  });

  final int index;
  final List<String> labels;
  final String createLabel;
  final ValueChanged<int> onSelected;
  final VoidCallback onCreate;

  static const _icons = [
    (AppIcons.dashboard, AppIcons.dashboardFilled),
    (AppIcons.invoice, AppIcons.invoiceFilled),
    (AppIcons.clients, AppIcons.clientFilled),
    (AppIcons.more, AppIcons.moreFilled),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: MediaQuery.withClampedTextScaling(
          maxScaleFactor: 1.3,
          child: LayoutBuilder(builder: _buildDock),
        ),
      ),
    );
  }

  /// Every pill is as wide as the longest label (capped to the screen),
  /// so the dock keeps one width and only the selection moves.
  Widget _buildDock(BuildContext context, BoxConstraints constraints) {
    const slot = AppSizes.minTapTarget + AppSpacing.xs;
    const rim = AppSpacing.xs * 2 + AppSizes.borderWidth * 2;
    final room = constraints.maxWidth - rim - slot * _icons.length;
    final pill = NavBarTab.pillWidthFor(
      context,
      labels,
    ).clamp(AppSizes.minTapTarget, room);
    return Center(
      child: _Dock(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < _icons.length; i++) ...[
              NavBarTab(
                icon: _icons[i].$1,
                selectedIcon: _icons[i].$2,
                label: labels[i],
                selected: index == i,
                width: pill,
                onTap: () => onSelected(i),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            NavBarCreateButton(tooltip: createLabel, onPressed: onCreate),
          ],
        ),
      ),
    );
  }
}

class _Dock extends StatelessWidget {
  const _Dock({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      height: AppSizes.navDockHeight,
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: ShapeDecoration(
        color: colors.surface,
        shape: StadiumBorder(side: BorderSide(color: colors.border)),
        shadows: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: AppOpacity.shadow),
            blurRadius: AppSpacing.xxl,
            offset: const Offset(0, AppSpacing.sm),
          ),
        ],
      ),
      child: child,
    );
  }
}
