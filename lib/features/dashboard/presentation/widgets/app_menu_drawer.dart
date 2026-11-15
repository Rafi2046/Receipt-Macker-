import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import 'app_menu_body.dart';

/// Side drawer matching the reference menu: profile, Pro, grouped links.
class AppMenuDrawer extends StatelessWidget {
  const AppMenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.86;
    return Drawer(
      backgroundColor: context.appColors.background,
      width: width.clamp(280.0, 360.0),
      child: SafeArea(
        child: AppMenuBody(onNavigate: () => Navigator.of(context).maybePop()),
      ),
    );
  }
}
