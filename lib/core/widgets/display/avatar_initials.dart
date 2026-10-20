import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../utils/initials.dart';

/// Circle with a name's initials (Bangla-aware). Decorative by default, since
/// the name is usually printed next to it; pass [semanticLabel] when it stands
/// alone so screen readers announce it.
class AvatarInitials extends StatelessWidget {
  const AvatarInitials({
    required this.name,
    this.size = AppSizes.avatarMd,
    this.semanticLabel,
    super.key,
  });

  final String name;
  final double size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final primary = context.appColors.primary;
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        padding: const EdgeInsets.all(AppSpacing.xs),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary.withValues(alpha: AppOpacity.tint),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            Initials.of(name),
            style: context.textStyles.labelLarge?.copyWith(color: primary),
          ),
        ),
      ),
    );
  }
}
