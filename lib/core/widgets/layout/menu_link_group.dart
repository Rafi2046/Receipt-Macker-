import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';

/// White rounded card that stacks [MenuLinkRow]s with inset dividers.
class MenuLinkGroup extends StatelessWidget {
  const MenuLinkGroup({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Material(
      color: colors.surface,
      borderRadius: AppRadius.card,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: AppSpacing.lg + AppSizes.iconMd + AppSpacing.md,
                color: colors.border,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}
