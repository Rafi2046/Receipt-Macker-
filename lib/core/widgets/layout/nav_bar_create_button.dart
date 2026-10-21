import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';

/// The gold "new invoice" circle at the end of [AppNavBar]. Gold keeps it
/// apart from the green selected tab, so it reads as an action.
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
        color: colors.secondary,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: AppSizes.minTapTarget,
            child: Icon(
              AppIcons.addRounded,
              color: colors.onSecondary,
              size: AppSizes.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}
