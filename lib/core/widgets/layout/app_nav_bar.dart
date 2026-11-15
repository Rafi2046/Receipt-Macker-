import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'nav_bar_create_button.dart';
import 'nav_bar_tab.dart';

/// Floating pill dock that spans the page width: four tab circles, the
/// selected one stretched into a labelled pill, and a create button at the
/// end. Tabs are spaced evenly so left and right stay balanced.
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
          AppSpacing.pagePadding,
          AppSpacing.xs,
          AppSpacing.pagePadding,
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
    const slot = AppSizes.minTapTarget;
    const rim = AppSpacing.xs * 2 + AppSizes.borderWidth * 2;
    // Four unselected circles + create leave the rest for the selected pill.
    final room = constraints.maxWidth - rim - slot * (_icons.length + 1);
    final pillCap = room < AppSizes.minTapTarget ? AppSizes.minTapTarget : room;
    final pill = NavBarTab.pillWidthFor(
      context,
      labels,
    ).clamp(AppSizes.minTapTarget, pillCap);
    return SizedBox(
      width: double.infinity,
      child: _Dock(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var i = 0; i < _icons.length; i++)
              NavBarTab(
                icon: _icons[i].$1,
                selectedIcon: _icons[i].$2,
                label: labels[i],
                selected: index == i,
                width: pill,
                onTap: () => onSelected(i),
              ),
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
        color: colors.surface.withValues(alpha: 0.94),
        shape: StadiumBorder(
          side: BorderSide(color: colors.border.withValues(alpha: 0.8)),
        ),
        shadows: [
          BoxShadow(
            color: colors.textPrimary.withValues(
              alpha: AppOpacity.shadow * 1.5,
            ),
            blurRadius: AppSpacing.xxl,
            offset: const Offset(0, AppSpacing.sm),
          ),
          BoxShadow(
            color: colors.primary.withValues(alpha: 0.04),
            blurRadius: AppSpacing.md,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}
