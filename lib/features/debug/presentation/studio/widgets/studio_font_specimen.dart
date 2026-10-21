import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_font.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import '../studio_type.dart';
import 'studio_card.dart';

/// Manrope and Plus Jakarta Sans, side by side, on the same sample.
class StudioFontSpecimen extends StatelessWidget {
  const StudioFontSpecimen({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final StudioFont selected;
  final ValueChanged<StudioFont> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sample = studioMoney(context, 2650000);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.studioFontTitle,
          style: context.studioType.titleSm(context.studio.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          l10n.studioFontBody,
          style: context.studioType.secondary(context.studio.muted),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _Sample(
                font: StudioFont.manrope,
                name: l10n.studioFontManrope,
                amount: sample,
                selected: selected == StudioFont.manrope,
                onTap: () => onSelected(StudioFont.manrope),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _Sample(
                font: StudioFont.jakarta,
                name: l10n.studioFontJakarta,
                amount: sample,
                selected: selected == StudioFont.jakarta,
                onTap: () => onSelected(StudioFont.jakarta),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Sample extends StatelessWidget {
  const _Sample({
    required this.font,
    required this.name,
    required this.amount,
    required this.selected,
    required this.onTap,
  });

  final StudioFont font;
  final String name;
  final String amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final type = StudioType(font.family);
    return DecoratedBox(
      decoration: studioCardDecoration(palette).copyWith(
        border: Border.all(
          color: selected ? palette.accent : palette.cardBorder,
          width: selected ? AppSizes.selectedBorderWidth : AppSizes.borderWidth,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.xl),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: type.label(palette.muted)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                amount,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: type.amount(palette.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
