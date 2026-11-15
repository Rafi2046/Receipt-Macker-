import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';

/// Compact create-invoice circle at the end of [AppNavBar].
class NavBarCreateButton extends StatelessWidget {
  const NavBarCreateButton({
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: colors.primary,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: AppSizes.navItemSize,
            child: Icon(
              AppIcons.addRounded,
              color: colors.onPrimary,
              size: AppSizes.navIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
