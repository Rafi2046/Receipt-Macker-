import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../domain/models/item.dart';

/// One item as a card: initials, name, muted details, and the price.
class ItemListTile extends StatelessWidget {
  const ItemListTile({required this.item, required this.onTap, super.key});

  final Item item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        spacing: AppSpacing.md,
        children: [
          AvatarInitials(name: item.name),
          Expanded(child: _ItemDetails(item: item)),
          _PriceBlock(item: item),
          Icon(
            AppIcons.chevronRight,
            size: AppSizes.iconMd,
            color: context.appColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _ItemDetails extends StatelessWidget {
  const _ItemDetails({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    final muted = context.textStyles.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    );
    final tax = item.defaultTaxBasisPoints;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textStyles.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        if (item.description.isNotEmpty)
          Text(
            item.description,
            style: muted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (item.unit.isNotEmpty)
          Text(
            item.unit,
            style: muted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        if (tax != null)
          Text(
            context.l10n.itemTaxLabel(format.percent(tax)),
            style: muted,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

class _PriceBlock extends StatelessWidget {
  const _PriceBlock({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.avatarLg * 2.5),
      child: AmountText(
        minor: item.unitPriceMinor,
        currencyCode: item.currencyCode,
        alignment: AlignmentDirectional.centerEnd,
      ),
    );
  }
}
