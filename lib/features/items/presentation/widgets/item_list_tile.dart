import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../domain/models/item.dart';

/// One item row: name, description and default tax on the left; price and
/// unit on the right.
class ItemListTile extends StatelessWidget {
  const ItemListTile({required this.item, required this.onTap, super.key});

  final Item item;
  final VoidCallback onTap;

  static const int _detailsFlex = 3;
  static const int _priceFlex = 2;

  @override
  Widget build(BuildContext context) {
    final secondary = context.textStyles.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    );
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pagePadding,
          vertical: AppSpacing.md,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.md,
          children: [
            Expanded(
              flex: _detailsFlex,
              child: _ItemDetails(item: item, secondary: secondary),
            ),
            // Price hugs the end edge; a very large amount shrinks to fit.
            Flexible(
              flex: _priceFlex,
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AmountText(
                      minor: item.unitPriceMinor,
                      currencyCode: item.currencyCode,
                      alignment: AlignmentDirectional.centerEnd,
                    ),
                    if (item.unit.isNotEmpty)
                      Text(
                        item.unit,
                        style: secondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemDetails extends StatelessWidget {
  const _ItemDetails({required this.item, required this.secondary});

  final Item item;
  final TextStyle? secondary;

  @override
  Widget build(BuildContext context) {
    final tax = item.defaultTaxBasisPoints;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: context.textStyles.bodyLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (item.description.isNotEmpty)
          Text(
            item.description,
            style: secondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (tax != null)
          Text(
            context.l10n.itemTaxLabel(format.percent(tax)),
            style: secondary,
          ),
      ],
    );
  }
}
