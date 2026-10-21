import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../studio_palette.dart';
import '../studio_scope.dart';

/// White card on the gray page. Dark mode uses a raised surface and a hairline.
class StudioCard extends StatelessWidget {
  const StudioCard({
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return DecoratedBox(
      decoration: studioCardDecoration(palette),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(StudioPalette.cardRadius),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

BoxDecoration studioCardDecoration(StudioPalette palette) {
  return BoxDecoration(
    color: palette.surface,
    borderRadius: BorderRadius.circular(StudioPalette.cardRadius),
    border: Border.all(color: palette.cardBorder),
    boxShadow: palette.cardShadows,
  );
}
