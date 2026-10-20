import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';

/// The screen's main "add" action, floating above a list. The label wraps
/// instead of overflowing at large font sizes.
class AppFab extends StatelessWidget {
  const AppFab({
    required this.label,
    required this.onPressed,
    this.icon = AppIcons.add,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        MediaQuery.sizeOf(context).width * AppSizes.fabLabelMaxWidthFactor;
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(icon),
      label: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
