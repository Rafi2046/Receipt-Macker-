import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'list_skeleton.dart';
import 'skeleton_box.dart';
import 'skeleton_card.dart';

/// Loading placeholder for Home (under its app bar): the outstanding card,
/// three overview totals and recent rows.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: context.l10n.loading,
      liveRegion: true,
      child: ExcludeSemantics(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.sm,
            AppSpacing.pagePadding,
            AppSpacing.lg,
          ),
          children: [
            const SkeletonCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.md,
                children: [
                  SkeletonBox(width: AppSizes.boneW3, height: AppSizes.boneSm),
                  SkeletonBox(width: AppSizes.boneW4, height: AppSizes.boneXl),
                  SkeletonBox(height: AppSizes.boneXs, radius: AppRadius.pill),
                  SkeletonBox(width: AppSizes.boneW2, height: AppSizes.boneSm),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              spacing: AppSpacing.sm,
              children: [
                for (var i = 0; i < 3; i++)
                  const Expanded(
                    child: SkeletonCard(
                      padding: EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: AppSpacing.sm,
                        children: [
                          SkeletonBox(
                            width: AppSizes.boneW1,
                            height: AppSizes.boneSm,
                          ),
                          SkeletonBox(
                            width: AppSizes.boneW2,
                            height: AppSizes.boneMd,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const SizedBox(
              height: AppSizes.skeletonRecentHeight,
              child: ListSkeleton(
                rows: 3,
                showSearch: false,
                showFilters: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
