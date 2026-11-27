import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'skeleton_box.dart';
import 'skeleton_card.dart';

/// Loading placeholder for a detail or editor page: a title card, then
/// cards of icon-and-text rows.
class FormSkeleton extends StatelessWidget {
  const FormSkeleton({this.cards = 3, super.key});

  final int cards;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.loading,
      liveRegion: true,
      child: ExcludeSemantics(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          children: [
            const SkeletonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  SkeletonBox(width: AppSizes.boneW4, height: AppSizes.boneLg),
                  SkeletonBox(width: AppSizes.boneW5, height: AppSizes.boneSm),
                ],
              ),
            ),
            for (var i = 0; i < cards; i++) ...[
              const SizedBox(height: AppSpacing.md),
              SkeletonCard(
                child: Column(
                  spacing: AppSpacing.lg,
                  children: [
                    for (var r = 0; r < 2; r++)
                      Row(
                        spacing: AppSpacing.md,
                        children: [
                          const SkeletonBox.circle(AppSizes.avatarMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: AppSpacing.sm,
                              children: [
                                FractionallySizedBox(
                                  widthFactor: r.isEven ? 0.5 : 0.65,
                                  child: const SkeletonBox(
                                    height: AppSizes.boneMd,
                                  ),
                                ),
                                FractionallySizedBox(
                                  widthFactor: r.isEven ? 0.75 : 0.4,
                                  child: const SkeletonBox(
                                    height: AppSizes.boneSm,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
