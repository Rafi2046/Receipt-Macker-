import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/pdf/brand_swatch.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/utils/color_from_hex.dart';
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

/// Slide art: large line icons on soft discs.
class IconsSlideArt extends StatelessWidget {
  const IconsSlideArt({required this.icons, super.key});

  final List<IconData> icons;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSpacing.xl,
      children: [
        for (final icon in icons)
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colors.surface,
              border: Border.all(color: colors.border),
            ),
            child: Icon(icon, size: AppSizes.iconXl, color: colors.primary),
          ),
      ],
    );
  }
}
