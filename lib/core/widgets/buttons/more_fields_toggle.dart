import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../utils/extensions/l10n_extension.dart';

/// "Show more fields" / "Show less fields" under a long form.
class MoreFieldsToggle extends StatelessWidget {
  const MoreFieldsToggle({
    required this.expanded,
    required this.onPressed,
    super.key,
  });

  final bool expanded;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              expanded ? l10n.clientShowLessFields : l10n.clientShowMoreFields,
              style: context.textStyles.labelLarge?.copyWith(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              expanded ? AppIcons.expandLess : AppIcons.expandMore,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
