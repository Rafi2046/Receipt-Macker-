import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_sizes.dart';

/// Round, outlined icon button for the top bar (Back and similar).
/// The visible circle is [AppSizes.topBarButton]; the tap target is 48dp.
class TopBarButton extends StatelessWidget {
  const TopBarButton({
    required this.icon,
    required this.semanticLabel,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Tooltip(
      message: semanticLabel,
      child: Semantics(
        button: true,
        label: semanticLabel,
        excludeSemantics: true,
        // The outer detector keeps the tap target at 48dp around the
        // smaller visible circle.
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: SizedBox.square(
            dimension: AppSizes.minTapTarget,
            child: Center(
              child: Material(
                color: colors.surface,
                clipBehavior: Clip.antiAlias,
                shape: CircleBorder(side: BorderSide(color: colors.border)),
                child: InkWell(
                  onTap: onPressed,
                  child: SizedBox.square(
                    dimension: AppSizes.topBarButton,
                    child: Icon(
                      icon,
                      size: AppSizes.iconSm,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
