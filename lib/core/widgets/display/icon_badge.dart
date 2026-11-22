import 'package:flutter/material.dart';

import '../../constants/app_opacity.dart';
import '../../constants/app_sizes.dart';

/// An icon on a soft round tint of its own [color].
class IconBadge extends StatelessWidget {
  const IconBadge({
    required this.icon,
    required this.color,
    this.size = AppSizes.avatarMd,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacity.tint),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: AppSizes.navIconSize),
    );
  }
}
