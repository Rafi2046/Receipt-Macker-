import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_opacity.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';

/// Dark summary panel at the top of the invoice editor: the number, the
/// running total and the issue → due dates.
class InvoiceEditorHero extends StatelessWidget {
  const InvoiceEditorHero({
    required this.number,
    required this.totalMinor,
    required this.currencyCode,
    required this.issueDate,
    required this.dueDate,
    super.key,
  });

  final String number;
  final int totalMinor;
  final String currencyCode;
  final DateTime issueDate;
  final DateTime dueDate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    // A dark panel in both themes.
    final panel = dark ? colors.surfaceAlt : colors.textPrimary;
    final onPanel = dark ? colors.textPrimary : colors.surface;
    final muted = onPanel.withValues(alpha: AppOpacity.mutedOnPanel);
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final caption = AppTextStyles.overline.copyWith(color: muted);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: panel,
        borderRadius: AppRadius.card,
        boxShadow: [
          BoxShadow(
            color: colors.textPrimary.withValues(alpha: AppOpacity.shadow),
            blurRadius: AppSpacing.xl,
            offset: const Offset(0, AppSpacing.sm),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.md,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSpacing.md,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(
                        l10n.fieldInvoiceNumber.toUpperCase(),
                        style: caption,
                      ),
                      Text(
                        number,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.titleLarge?.copyWith(
                          color: onPanel,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    spacing: AppSpacing.xs,
                    children: [
                      Text(l10n.totalTotal.toUpperCase(), style: caption),
                      AmountText(
                        minor: totalMinor,
                        currencyCode: currencyCode,
                        size: AmountTextSize.lg,
                        color: onPanel,
                        alignment: AlignmentDirectional.centerEnd,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Wrap(
              spacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(AppIcons.date, size: AppSizes.iconSm, color: muted),
                Text(
                  format.date(issueDate),
                  style: context.textStyles.bodySmall?.copyWith(color: muted),
                ),
                Icon(AppIcons.forward, size: AppSizes.iconSm, color: muted),
                Text(
                  format.date(dueDate),
                  style: context.textStyles.bodySmall?.copyWith(color: onPanel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
