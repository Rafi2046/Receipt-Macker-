import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'shimmer.dart';
import 'skeleton_box.dart';
import 'skeleton_card.dart';

/// Loading placeholder for a list screen: a search bar, filter pills and
/// card rows shaped like the real ones (avatar, two lines, amount).
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    this.rows = 6,
    this.showSearch = true,
    this.showFilters = true,
    super.key,
  });

  final int rows;
  final bool showSearch;
  final bool showFilters;

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
            if (showSearch) ...[
              const Shimmer(
                child: SkeletonBox(
                  height: AppSizes.buttonHeight,
                  radius: AppRadius.pill,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (showFilters) ...[
              // The pills run off the edge on a narrow phone, as the real
              // filter row does; they are clipped, never squeezed.
              const SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                child: Shimmer(
                  child: Row(
                    spacing: AppSpacing.sm,
                    children: [
                      SkeletonBox(
                        width: AppSizes.boneW1,
                        height: AppSizes.bonePill,
                        radius: AppRadius.pill,
                      ),
                      SkeletonBox(
                        width: AppSizes.boneW2,
                        height: AppSizes.bonePill,
                        radius: AppRadius.pill,
                      ),
                      SkeletonBox(
                        width: AppSizes.boneW3,
                        height: AppSizes.bonePill,
                        radius: AppRadius.pill,
                      ),
                      SkeletonBox(
                        width: AppSizes.boneW2,
                        height: AppSizes.bonePill,
                        radius: AppRadius.pill,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            for (var i = 0; i < rows; i++) ...[
              // Rows vary a little, as real names and amounts do.
              _Row(wide: i.isEven),
              const SizedBox(height: AppSpacing.sm),
            ],
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    return SkeletonCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          const SkeletonBox.circle(AppSizes.avatarMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.sm,
              children: [
                FractionallySizedBox(
                  widthFactor: wide ? 0.8 : 0.6,
                  child: const SkeletonBox(height: AppSizes.boneMd),
                ),
                FractionallySizedBox(
                  widthFactor: wide ? 0.5 : 0.7,
                  child: const SkeletonBox(height: AppSizes.boneSm),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: AppSpacing.sm,
            children: [
              SkeletonBox(
                width: wide ? AppSizes.boneW2 : AppSizes.boneW1,
                height: AppSizes.boneMd,
              ),
              const SkeletonBox(
                width: AppSizes.boneW1,
                height: AppSizes.boneMd,
                radius: AppRadius.pill,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
