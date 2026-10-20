import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

/// Icon-only button with a required screen-reader label (also its tooltip)
/// and a 48dp tap target.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    this.filled = false,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;
  final bool filled;

  static const BoxConstraints _target = BoxConstraints(
    minWidth: AppSizes.minTapTarget,
    minHeight: AppSizes.minTapTarget,
  );

  @override
  Widget build(BuildContext context) {
    final glyph = Icon(icon);
    return filled
        ? IconButton.filledTonal(
            onPressed: onPressed,
            icon: glyph,
            tooltip: semanticLabel,
            constraints: _target,
          )
        : IconButton(
            onPressed: onPressed,
            icon: glyph,
            tooltip: semanticLabel,
            constraints: _target,
          );
  }
}
