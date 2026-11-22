import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'nav_bar_create_button.dart';
import 'nav_bar_tab.dart';

/// Floating dock: two tabs, the create button in the middle, two tabs.
/// Every tab shows its icon and label; the selected one is brand-tinted.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.index,
    required this.labels,
    required this.createLabel,
    required this.onSelected,
    required this.onCreate,
    super.key,
  }) : assert(labels.length == 4, 'The dock has exactly four tabs.');

  final int index;
  final List<String> labels;
  final String createLabel;
  final ValueChanged<int> onSelected;
  final VoidCallback onCreate;

  static const _icons = [
    AppIcons.dashboard,
    AppIcons.invoice,
    AppIcons.quote,
    AppIcons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    Widget tab(int i) => Expanded(
      child: NavBarTab(
        icon: _icons[i],
        label: labels[i],
        selected: index == i,
        onTap: () => onSelected(i),
      ),
    );
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
          child: _Dock(
            child: Row(
              children: [
                tab(0),
                tab(1),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                  ),
                  child: NavBarCreateButton(
                    tooltip: createLabel,
                    onPressed: onCreate,
                  ),
                ),
                tab(2),
                tab(3),
              ],
            ),
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: const BorderRadius.all(Radius.circular(AppSpacing.xxl)),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(
              alpha: AppOpacity.shadow * 1.5,
            ),
            blurRadius: AppSpacing.xxl,
            offset: const Offset(0, AppSpacing.sm),
          ),
        ],
      ),
      child: child,
    );
  }
}
