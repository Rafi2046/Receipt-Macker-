import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/pdf/brand_swatch.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/utils/color_from_hex.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/avatar_initials.dart';
import '../../../../core/widgets/pdf/mini_layout_thumbnail.dart';

/// Slide art: three Pro templates fanned out.
class TemplatesSlideArt extends StatelessWidget {
  const TemplatesSlideArt({super.key});

  @override
  Widget build(BuildContext context) {
    final fallback = context.appColors.primary;
    final pro = PdfTemplate.values.where((t) => t.requiresPro).toList();
    Widget page(int i, BrandSwatch swatch, double angle, Offset shift) =>
        Transform.translate(
          offset: shift,
          child: Transform.rotate(
            angle: angle,
            child: MiniLayoutThumbnail(
              template: pro[i % pro.length],
              accentColor: colorFromHex(swatch.hex, fallback: fallback),
              width: AppSizes.colorPreviewWidth,
              height: AppSizes.colorPreviewHeight,
            ),
          ),
        );
    return Stack(
      alignment: Alignment.center,
      children: [
        page(3, BrandSwatch.teal, -0.14, const Offset(-70, 8)),
        page(8, BrandSwatch.plum, 0.14, const Offset(70, 8)),
        page(0, BrandSwatch.royal, 0, Offset.zero),
      ],
    );
  }
}

/// Slide art: an invoice with a strip of brand colors under it.
class ColorsSlideArt extends StatelessWidget {
  const ColorsSlideArt({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const swatches = [
      BrandSwatch.coral,
      BrandSwatch.royal,
      BrandSwatch.emerald,
      BrandSwatch.plum,
      BrandSwatch.amber,
      BrandSwatch.teal,
    ];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSpacing.md,
      children: [
        MiniLayoutThumbnail(
          template: PdfTemplate.values.first,
          accentColor: colorFromHex(
            BrandSwatch.emerald.hex,
            fallback: colors.primary,
          ),
          width: AppSizes.colorPreviewWidth * 0.8,
          height: AppSizes.colorPreviewHeight * 0.8,
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.all(
              Radius.circular(AppSpacing.xxl),
            ),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.sm,
            children: [
              for (final s in swatches)
                Container(
                  width: AppSpacing.xxl,
                  height: AppSpacing.xxl,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorFromHex(s.hex, fallback: colors.primary),
                  ),
                ),
              Icon(
                AppIcons.add,
                size: AppSizes.iconRow,
                color: colors.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Slide art: an invoice with two floating labels (what Pro removes).
class CleanSlideArt extends StatelessWidget {
  const CleanSlideArt({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return _FloatingArt(
      center: MiniLayoutThumbnail(
        template: PdfTemplate.values.first,
        accentColor: colorFromHex(
          BrandSwatch.navy.hex,
          fallback: colors.primary,
        ),
        width: AppSizes.colorPreviewWidth,
        height: AppSizes.colorPreviewHeight,
      ),
      topChip: (AppIcons.noAds, l10n.paywallChipNoAds),
      bottomChip: (AppIcons.noFooter, l10n.paywallChipNoFooter),
    );
  }
}

/// Slide art: a row of client avatars with two floating labels.
class UnlimitedSlideArt extends StatelessWidget {
  const UnlimitedSlideArt({super.key});

  static const List<String> _names = ['A K', 'R S', 'M T', 'N H'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    const overlap = AppSizes.avatarLg * 0.72;
    return _FloatingArt(
      center: SizedBox(
        width: overlap * (_names.length - 1) + AppSizes.avatarLg,
        height: AppSizes.avatarLg,
        child: Stack(
          children: [
            for (var i = 0; i < _names.length; i++)
              Positioned(
                left: overlap * i,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Solid behind the tinted avatar, so overlaps stay clean.
                    color: colors.surface,
                    border: Border.all(
                      color: colors.background,
                      width: AppSizes.selectedBorderWidth,
                    ),
                  ),
                  child: AvatarInitials(
                    name: _names[i],
                    size: AppSizes.avatarLg,
                  ),
                ),
              ),
          ],
        ),
      ),
      topChip: (AppIcons.clients, l10n.paywallChipClients),
      bottomChip: (AppIcons.item, l10n.paywallChipItems),
    );
  }
}

/// [center] with one chip floating top-right and one bottom-left.
class _FloatingArt extends StatelessWidget {
  const _FloatingArt({
    required this.center,
    required this.topChip,
    required this.bottomChip,
  });

  final Widget center;
  final (IconData, String) topChip;
  final (IconData, String) bottomChip;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        center,
        Align(
          alignment: const Alignment(0.85, -0.7),
          child: _Chip(icon: topChip.$1, label: topChip.$2),
        ),
        Align(
          alignment: const Alignment(-0.85, 0.75),
          child: _Chip(icon: bottomChip.$1, label: bottomChip.$2),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppRadius.chip,
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.panel.withValues(alpha: 0.18),
            blurRadius: AppSpacing.md,
            offset: const Offset(0, AppSpacing.xs),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.sm,
        children: [
          Icon(icon, size: AppSizes.iconRow, color: colors.primary),
          Text(
            label,
            style: context.textStyles.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
