import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// Floating tab bar with a raised button for a new invoice.
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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.sm,
        ),
        child: SizedBox(
          height: AppSizes.navBarHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.xxl),
                  border: Border.all(color: colors.border),
                ),
                child: Material(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.xxl),
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      _Tab(
                        icon: AppIcons.dashboard,
                        filled: AppIcons.dashboardFilled,
                        label: labels[0],
                        selected: index == 0,
                        onTap: () => onSelected(0),
                      ),
                      _Tab(
                        icon: AppIcons.invoice,
                        filled: AppIcons.invoiceFilled,
                        label: labels[1],
                        selected: index == 1,
                        onTap: () => onSelected(1),
                      ),
                      const SizedBox(width: AppSizes.avatarLg),
                      _Tab(
                        icon: AppIcons.clients,
                        filled: AppIcons.clientFilled,
                        label: labels[2],
                        selected: index == 2,
                        onTap: () => onSelected(2),
                      ),
                      _Tab(
                        icon: AppIcons.more,
                        filled: AppIcons.moreFilled,
                        label: labels[3],
                        selected: index == 3,
                        onTap: () => onSelected(3),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -AppSpacing.md,
                child: _Create(tooltip: createLabel, onPressed: onCreate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.icon,
    required this.filled,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData filled;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = selected ? colors.primary : colors.textSecondary;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: selected
                      ? colors.primary.withValues(alpha: 0.12)
                      : null,
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  child: Icon(
                    selected ? filled : icon,
                    color: color,
                    size: AppSizes.iconMd,
                  ),
                ),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.labelSmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Create extends StatelessWidget {
  const _Create({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: colors.primary,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: AppSizes.avatarLg,
            height: AppSizes.avatarLg,
            child: Icon(
              AppIcons.addRounded,
              color: colors.onPrimary,
              size: AppSizes.iconLg,
            ),
          ),
        ),
      ),
    );
  }
}
