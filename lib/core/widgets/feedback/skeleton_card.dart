import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import 'shimmer.dart';

/// A card outline whose [child] bones shimmer. The frame itself stays
/// still, so the page keeps its shape while loading.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.card,
        border: Border.all(color: colors.border),
      ),
      child: Shimmer(child: child),
    );
  }
}
