import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'nav_bar_create_button.dart';
import 'nav_bar_tab.dart';

/// Floating dock: four tabs with a sliding pill indicator and a create
/// button for a new invoice in the middle.
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

  Widget _tab(int i) => NavBarTab(
    icon: _icons[i].$1,
    selectedIcon: _icons[i].$2,
    label: labels[i],
    selected: index == i,
    onTap: () => onSelected(i),
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final height = MediaQuery.textScalerOf(context)
        .clamp(maxScaleFactor: 1.4)
        .scale(AppSizes.navBarHeight);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.md,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: AppRadius.dock,
            border: Border.all(color: colors.border),
            boxShadow: [
              BoxShadow(
                color: colors.textPrimary.withValues(alpha: AppOpacity.shadow),
                blurRadius: AppSpacing.xxxl,
                offset: const Offset(0, AppSpacing.md),
              ),
            ],
          ),
          child: Material(
            type: MaterialType.transparency,
            child: SizedBox(
              height: height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Row(
                  children: [
                    _tab(0),
                    _tab(1),
                    NavBarCreateButton(
                      tooltip: createLabel,
                      onPressed: onCreate,
                    ),
                    _tab(2),
                    _tab(3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
