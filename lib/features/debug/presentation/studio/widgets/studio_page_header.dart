import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_icons.dart';
import '../studio_scope.dart';

/// Back arrow and a title for screens that cover the tab bar.
class StudioPageHeader extends StatelessWidget {
  const StudioPageHeader({
    required this.title,
    required this.onBack,
    super.key,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          IconButton(
            tooltip: context.l10n.back,
            onPressed: onBack,
            iconSize: AppSizes.iconMd,
            icon: Icon(StudioIcons.back, color: palette.ink),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.studioType.title(palette.ink),
            ),
          ),
        ],
      ),
    );
  }
}
