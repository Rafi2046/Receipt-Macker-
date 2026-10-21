import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_icons.dart';
import '../studio_scope.dart';

/// Soft warning for overdue invoices, with a review action.
class StudioOverdueBanner extends StatelessWidget {
  const StudioOverdueBanner({required this.onReview, super.key});

  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.warningWash,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(
              StudioIcons.warning,
              color: palette.warningInk,
              size: AppSizes.iconMd,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                l10n.overdueBannerPreview,
                style: context.studioType.body(palette.warningInk),
              ),
            ),
            TextButton(
              onPressed: onReview,
              child: Text(
                l10n.studioReview,
                style: context.studioType.label(palette.warningInk),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
