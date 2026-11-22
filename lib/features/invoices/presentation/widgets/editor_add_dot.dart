import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';

/// The round "+" at the end of an editor row that adds something.
class EditorAddDot extends StatelessWidget {
  const EditorAddDot({super.key});

  static const double _size = 28;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      width: _size,
      height: _size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
      child: Icon(
        AppIcons.addRounded,
        color: colors.onPrimary,
        size: AppSizes.navIconSize,
      ),
    );
  }
}
