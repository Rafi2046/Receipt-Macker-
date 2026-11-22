import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/layout/app_card.dart';

/// A titled settings card: a small heading above a card of rows split by
/// dividers that start after the row icons.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    required this.title,
    required this.children,
    this.dividerIndent = _iconIndent,
    super.key,
  });

  final String title;
  final List<Widget> children;

  /// Where dividers start; by default just after the row icons.
  final double dividerIndent;

  static const double _iconIndent =
      AppSpacing.lg + AppSizes.iconRow + AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xs,
            0,
            AppSpacing.xs,
            AppSpacing.sm,
          ),
          child: Text(
            title.toUpperCase(),
            style: context.textStyles.labelMedium?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: AppSizes.borderWidth,
                    indent: dividerIndent,
                    color: colors.border,
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
