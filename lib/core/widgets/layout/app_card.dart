import 'package:flutter/material.dart';

import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';

/// Bordered surface. Tappable when [onTap] is set.
class AppCard extends StatelessWidget {
  const AppCard({required this.child, this.onTap, this.padding, super.key});

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
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
