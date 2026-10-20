import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../domain/models/invoice_totals.dart';
import '../../domain/models/line_item.dart';

/// One invoice line: name, "quantity unit × price", and the line total.
/// Tappable in the editor; shows a warning when the line has errors.
class LineItemRow extends StatelessWidget {
  const LineItemRow({
    required this.line,
    required this.totals,
    required this.currencyCode,
    this.hasError = false,
    this.onTap,
    super.key,
  });

  final LineItem line;
  final LineTotals totals;
  final String currencyCode;
  final bool hasError;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final colors = context.appColors;
    final qty = [
      format.quantity(line.quantityMilli),
      if (line.unit.isNotEmpty) line.unit,
    ].join(' ');
    final detail = l10n.lineQuantityPrice(
      qty,
      format.currency(line.unitPriceMinor, currencyCode),
    );
    final secondary = context.textStyles.bodySmall?.copyWith(
      color: colors.textSecondary,
    );
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            Expanded(
              flex: _nameFlex,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.name.isEmpty ? l10n.lineEditTitle : line.name,
                    style: context.textStyles.bodyLarge,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(detail, style: secondary),
                  if (hasError)
                    Row(
                      spacing: AppSpacing.xs,
                      children: [
                        Icon(
                          AppIcons.error,
                          size: AppSizes.iconSm,
                          color: colors.danger,
                        ),
                        Flexible(
                          child: Text(
                            l10n.validationFixErrors,
                            style: secondary?.copyWith(color: colors.danger),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Flexible(
              flex: _amountFlex,
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: AmountText(
                  minor: totals.net,
                  currencyCode: currencyCode,
                  alignment: AlignmentDirectional.centerEnd,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const int _nameFlex = 3;
  static const int _amountFlex = 2;
}
