import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/utils/initials.dart';
import '../studio_scope.dart';

/// Initials whose color comes from the name, so the same client stays the same.
class StudioAvatar extends StatelessWidget {
  const StudioAvatar({
    required this.name,
    super.key,
    this.size = AppSizes.avatarMd,
  });

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.avatarBackground(name),
        shape: BoxShape.circle,
      ),
      child: Text(
        Initials.of(name),
        style: context.studioType.label(palette.avatarForeground(name)),
      ),
    );
  }
}
