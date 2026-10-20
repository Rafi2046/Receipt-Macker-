import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';

/// Shows the semantic surface and brand colors of the current theme.
class ColorSwatchGrid extends StatelessWidget {
  const ColorSwatchGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final l10n = context.l10n;
    final swatches = [
      (l10n.colorPrimary, c.primary),
      (l10n.colorSecondary, c.secondary),
      (l10n.colorSurface, c.surface),
      (l10n.colorSurfaceAlt, c.surfaceAlt),
      (l10n.colorBorder, c.border),
      (l10n.colorTextSecondary, c.textSecondary),
    ];
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        for (final (label, color) in swatches)
          _Swatch(label: label, color: color),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.swatchWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppSizes.swatch,
            decoration: BoxDecoration(
              color: color,
              borderRadius: AppRadius.card,
              border: Border.all(color: context.appColors.border),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: context.textStyles.labelMedium),
        ],
      ),
    );
  }
}
