import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import 'launcher_icon_preview.dart';

/// The three concepts on a mock home-screen wallpaper, labelled like apps,
/// once per launcher mask.
class WallpaperPanel extends StatelessWidget {
  const WallpaperPanel({
    required this.gradient,
    required this.labelColor,
    super.key,
  });

  final List<Color> gradient;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          spacing: AppSpacing.lg,
          children: [
            for (final mask in LauncherMask.values)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final (i, asset) in AppImages.logoConcepts.indexed)
                    _AppSlot(
                      asset: asset,
                      mask: mask,
                      label: context.l10n.logoConceptName(
                        String.fromCharCode('A'.codeUnitAt(0) + i),
                      ),
                      labelColor: labelColor,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _AppSlot extends StatelessWidget {
  const _AppSlot({
    required this.asset,
    required this.mask,
    required this.label,
    required this.labelColor,
  });

  final String asset;
  final LauncherMask mask;
  final String label;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.xs,
      children: [
        LauncherIconPreview(
          asset: asset,
          size: AppSizes.launcherIcon,
          mask: mask,
        ),
        Text(
          label,
          style: context.textStyles.labelSmall?.copyWith(color: labelColor),
        ),
      ],
    );
  }
}
