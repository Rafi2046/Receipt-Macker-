import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/display/icon_badge.dart';

/// One tappable row of the invoice editor: an icon (on a tinted badge when
/// [tone] is set), a title with an optional subtitle, an optional [value]
/// on the right, and a chevron or another [trailing] widget.
class EditorRow extends StatelessWidget {
  const EditorRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    this.tone,
    this.trailing,
    this.hasError = false,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final Color? tone;
  final Widget? trailing;

  /// Shows the subtitle in the danger color.
  final bool hasError;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = context.textStyles;
    final tone = this.tone;
    final subtitle = this.subtitle;
    final value = this.value;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.minTapTarget),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            spacing: AppSpacing.md,
            children: [
              if (tone != null)
                IconBadge(icon: icon, color: tone)
              else
                Icon(icon, color: colors.textPrimary, size: AppSizes.iconMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSpacing.xxs,
                  children: [
                    Text(
                      title,
                      style: text.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: text.bodySmall?.copyWith(
                          color: hasError
                              ? colors.danger
                              : colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              if (value != null)
                Expanded(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: text.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              trailing ??
                  Icon(AppIcons.chevronRight, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
