import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'nav_bar_create_button.dart';
import 'nav_bar_tab.dart';

/// Floating pill dock: compact icons, selected labelled pill, create button.
/// Fixed gaps keep items from stacking; leftover width stays evenly shared.
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
    (AppIcons.quote, AppIcons.quoteFilled),
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

  Widget _buildDock(BuildContext context, BoxConstraints constraints) {
    const slot = AppSizes.navItemSize;
    const gap = AppSpacing.sm;
    const rim = AppSpacing.sm * 2 + AppSizes.borderWidth * 2;
    // Unselected tabs + create, with a fixed gap before each item.
    final reserved = slot * _icons.length + gap * _icons.length;
    final room = constraints.maxWidth - rim - reserved;
    final needed = NavBarTab.pillWidthFor(context, labels);
    final pillCap = room < slot ? slot.toDouble() : room;
    final pill = needed.clamp(slot.toDouble(), pillCap);
    return SizedBox(
      width: double.infinity,
      child: _Dock(
        child: Row(
          children: [
            for (var i = 0; i < _icons.length; i++) ...[
              if (i > 0) ...[const SizedBox(width: gap), const Spacer()],
              NavBarTab(
                icon: _icons[i].$1,
                selectedIcon: _icons[i].$2,
                label: labels[i],
                selected: index == i,
                width: pill,
                onTap: () => onSelected(i),
              ),
            ],
            const SizedBox(width: gap),
            const Spacer(),
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
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      alignment: Alignment.center,
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
