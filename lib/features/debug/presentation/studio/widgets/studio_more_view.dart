import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_font.dart';
import '../studio_icons.dart';
import '../studio_scope.dart';
import 'studio_card.dart';
import 'studio_font_specimen.dart';

/// Grouped menu, the Pro card, and the side-by-side font choice.
class StudioMoreView extends StatelessWidget {
  const StudioMoreView({required this.font, required this.onFont, super.key});

  final StudioFont font;
  final ValueChanged<StudioFont> onFont;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.sm,
        AppSpacing.pagePadding,
        AppSpacing.lg,
      ),
      children: [
        Text(l10n.navMore, style: context.studioType.title(context.studio.ink)),
        const SizedBox(height: AppSpacing.lg),
        StudioFontSpecimen(selected: font, onSelected: onFont),
        const SizedBox(height: AppSpacing.xl),
        _GroupLabel(l10n.studioGroupBusiness),
        _Tile(icon: StudioIcons.business, label: l10n.businessProfileTitle),
        _Tile(icon: StudioIcons.items, label: l10n.itemsTitle),
        _Tile(icon: StudioIcons.payment, label: l10n.studioPaymentsReceipts),
        _Tile(icon: StudioIcons.design, label: l10n.studioInvoiceDesign),
        const SizedBox(height: AppSpacing.lg),
        _GroupLabel(l10n.studioGroupApp),
        _Tile(icon: StudioIcons.settings, label: l10n.studioSettings),
        _Tile(icon: StudioIcons.backup, label: l10n.studioBackup),
        const SizedBox(height: AppSpacing.lg),
        const _ProCard(),
        const SizedBox(height: AppSpacing.md),
        _Tile(icon: StudioIcons.help, label: l10n.studioHelpLegal),
      ],
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(label, style: context.studioType.label(context.studio.muted)),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: StudioCard(
        onTap: () {},
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: AppSizes.minTapTarget,
              height: AppSizes.minTapTarget,
              decoration: BoxDecoration(
                color: palette.wash(palette.accent),
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              child: Icon(icon, color: palette.accent, size: AppSizes.iconMd),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: context.studioType.titleSm(palette.ink),
              ),
            ),
            Icon(StudioIcons.chevronRight, color: palette.muted),
          ],
        ),
      ),
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: studioCardDecoration(palette)
          .copyWith(border: Border.all(color: palette.gold)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Icon(
              StudioIcons.pro,
              color: palette.goldInk,
              size: AppSizes.iconLg,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.studioProTitle,
                    style: context.studioType.titleSm(palette.ink),
                  ),
                  Text(
                    l10n.studioProBody,
                    style: context.studioType.secondary(palette.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
