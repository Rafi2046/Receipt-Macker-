import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// Round "more filters" button for list screens; a dot shows when any
/// extra filter is on.
class FilterIconButton extends StatelessWidget {
  const FilterIconButton({
    required this.active,
    required this.tooltip,
    required this.onTap,
    super.key,
  });

  final bool active;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: active ? colors.primary.withValues(alpha: 0.12) : colors.surface,
        shape: CircleBorder(
          side: BorderSide(color: active ? colors.primary : colors.border),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(
            dimension: AppSizes.minTapTarget - AppSpacing.sm,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  AppIcons.filter,
                  size: AppSizes.iconRow,
                  color: active ? colors.primary : colors.textSecondary,
                ),
                if (active)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      width: AppSpacing.sm,
                      height: AppSpacing.sm,
                      decoration: BoxDecoration(
                        color: colors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.surface),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
