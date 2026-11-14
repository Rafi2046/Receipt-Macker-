import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';

/// Bordered surface. Tappable when [onTap] is set.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.borderColor,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: borderColor != null
          ? RoundedRectangleBorder(
              borderRadius: AppRadius.card,
              side: BorderSide(color: borderColor!),
            )
          : null,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );
  }
}
