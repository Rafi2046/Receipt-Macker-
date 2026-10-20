import 'package:flutter/material.dart';

import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import 'direction_palette.dart';

/// A status word on a tinted pill. Color never appears without the label.
class DirectionStatus extends StatelessWidget {
  const DirectionStatus({
    required this.label,
    required this.color,
    required this.palette,
    super.key,
  });

  final String label;
  final Color color;
  final DirectionPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: palette.wash(color),
        borderRadius: AppRadius.chip,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
