import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_radius.dart';

/// One bone of a skeleton: a rounded block (or a circle) in the muted
/// surface color. Put it under a [Shimmer].
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    this.width,
    required this.height,
    this.radius = AppRadius.sm,
    super.key,
  });

  /// A circle of [size], for avatars.
  const SkeletonBox.circle(double size, {super.key})
    : width = size,
      height = size,
      radius = AppRadius.pill;

  /// Null fills the available width.
  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.appColors.surfaceAlt,
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}
