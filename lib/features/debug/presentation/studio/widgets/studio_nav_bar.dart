import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../studio_icons.dart';
import '../studio_palette.dart';
import '../studio_scope.dart';

/// Floating bar with a raised center button for a new invoice.
class StudioNavBar extends StatelessWidget {
  const StudioNavBar({
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
              _Bar(index: index, labels: labels, onSelected: onSelected),
              Positioned(
                top: -AppSpacing.md,
                child: _CreateButton(tooltip: createLabel, onPressed: onCreate),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.index,
    required this.labels,
    required this.onSelected,
  });

  final int index;
  final List<String> labels;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(StudioPalette.navRadius),
        border: Border.all(color: palette.cardBorder),
        boxShadow: palette.barShadows,
      ),
      child: Material(
        color: palette.surface,
        borderRadius: BorderRadius.circular(StudioPalette.navRadius),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            _Tab(
              icon: StudioIcons.home,
              filled: StudioIcons.homeFilled,
              label: labels[0],
              selected: index == 0,
              onTap: () => onSelected(0),
            ),
            _Tab(
              icon: StudioIcons.invoices,
              filled: StudioIcons.invoicesFilled,
              label: labels[1],
              selected: index == 1,
              onTap: () => onSelected(1),
            ),
            const SizedBox(width: AppSizes.avatarLg),
            _Tab(
              icon: StudioIcons.clients,
              filled: StudioIcons.clientsFilled,
              label: labels[2],
              selected: index == 2,
              onTap: () => onSelected(2),
            ),
            _Tab(
              icon: StudioIcons.more,
              filled: StudioIcons.moreFilled,
              label: labels[3],
              selected: index == 3,
              onTap: () => onSelected(3),
            ),
          ],
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
    final palette = context.studio;
    final color = selected ? palette.accent : palette.muted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(StudioPalette.navRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: selected ? palette.wash(palette.accent) : null,
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
                style: context.studioType.label(color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: palette.accent,
        shape: const CircleBorder(),
        elevation: 4,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox(
            width: AppSizes.avatarLg,
            height: AppSizes.avatarLg,
            child: Icon(
              StudioIcons.add,
              color: palette.onAccent,
              size: AppSizes.iconLg,
            ),
          ),
        ),
      ),
    );
  }
}
