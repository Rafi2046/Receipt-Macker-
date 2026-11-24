import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/stamp_placement.dart';
import '../../utils/extensions/l10n_extension.dart';

/// Compact stamp-position popup used on the invoice PDF options bar.
class StampPlacementRow extends StatelessWidget {
  const StampPlacementRow({
    required this.placement,
    required this.onSelected,
    this.enabled = true,
    super.key,
  });

  final StampPlacement placement;
  final ValueChanged<StampPlacement> onSelected;
  final bool enabled;

  static String labelFor(AppLocalizations l10n, StampPlacement p) =>
      switch (p) {
        StampPlacement.none => l10n.stampPlacementNone,
        StampPlacement.center => l10n.stampPlacementCenter,
        StampPlacement.topRight => l10n.stampPlacementTopRight,
        StampPlacement.bottomRight => l10n.stampPlacementBottomRight,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<StampPlacement>(
      tooltip: l10n.stampPlacementLabel,
      enabled: enabled,
      initialValue: placement,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final p in StampPlacement.values)
          PopupMenuItem(value: p, child: Text(labelFor(l10n, p))),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Icon(
              AppIcons.stamp,
              size: AppSizes.iconSm,
              color: context.appColors.primary,
            ),
            Text(
              labelFor(l10n, placement),
              style: context.textStyles.labelLarge?.copyWith(
                color: context.appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
