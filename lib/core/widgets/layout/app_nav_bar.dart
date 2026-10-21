import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'nav_bar_create_button.dart';
import 'nav_bar_tab.dart';

/// Floating pill dock: four tab circles, the selected one stretched into
/// a labelled pill, and a create button for a new invoice at the end.
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
    // The selected pill takes every pixel the circles leave, so the dock
    // has no empty gap on any screen width.
    final tabs = LayoutBuilder(
      builder: (context, constraints) {
        const circles = AppSizes.minTapTarget + AppSpacing.xs;
        final pill = constraints.maxWidth - circles * (_icons.length - 1);
        return Row(
          children: [
            for (var i = 0; i < _icons.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.xs),
              _tab(i, pill),
            ],
          ],
        );
      },
    );
    final children = <Widget>[
      Expanded(child: tabs),
      const SizedBox(width: AppSpacing.xs),
      NavBarCreateButton(tooltip: createLabel, onPressed: onCreate),
    ];
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
          child: _Dock(child: Row(children: children)),
        ),
      ),
    );
  }

  Widget _tab(int i, double pillWidth) => NavBarTab(
    icon: _icons[i].$1,
    selectedIcon: _icons[i].$2,
    label: labels[i],
    selected: index == i,
    width: index == i ? pillWidth : AppSizes.minTapTarget,
    onTap: () => onSelected(i),
  );
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
