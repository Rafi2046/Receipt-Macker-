import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/brand_swatch.dart';
import '../../services/pdf/pdf_template.dart';
import '../../utils/color_from_hex.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../../utils/hex_color.dart';
import 'accent_dot.dart';
import 'custom_color_sheet.dart';
import 'pdf_template_labels.dart';

/// The invoice color choice: the logo's color (when there is a logo), a
/// custom color, then the curated swatches.
class AccentColorRow extends StatelessWidget {
  const AccentColorRow({
    required this.selectedHex,
    required this.template,
    required this.onSelected,
    this.logoHex,
    this.enabled = true,
    super.key,
  });

  /// The current accent; null means the default (coral).
  final String? selectedHex;
  final PdfTemplate template;
  final String? logoHex;
  final bool enabled;
  final ValueChanged<String> onSelected;

  bool _same(String? a, String? b) =>
      HexColor.normalize(a ?? '') != null &&
      HexColor.normalize(a ?? '') == HexColor.normalize(b ?? '');

  Future<void> _custom(BuildContext context, String current) async {
    final hex = await CustomColorSheet.show(
      context,
      initialHex: current,
      template: template,
    );
    if (hex != null) onSelected(hex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final current = selectedHex ?? BrandSwatch.coral.hex;
    final logo = logoHex;
    final isLogo = logo != null && _same(current, logo);
    final isCustom = !isLogo && !BrandSwatch.isPreset(current);
    VoidCallback? tap(VoidCallback action) => enabled ? action : null;
    Color fill(String hex) => colorFromHex(hex, fallback: colors.primary);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (logo != null)
            AccentDot(
              label: l10n.accentLogoColor,
              color: fill(logo),
              selected: isLogo,
              badge: AppIcons.logoColor,
              onTap: tap(() => onSelected(logo)),
            ),
          AccentDot(
            label: l10n.accentCustomColor,
            color: isCustom ? fill(current) : null,
            gradient: isCustom ? null : _rainbow(fill),
            selected: isCustom,
            centerIcon: AppIcons.add,
            badge: isCustom ? AppIcons.edit : null,
            onTap: tap(() => _custom(context, current)),
          ),
          Container(
            width: AppSizes.borderWidth,
            height: AppSpacing.xxl,
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            color: colors.border,
          ),
          for (final swatch in BrandSwatch.values)
            AccentDot(
              label: l10n.swatchName(swatch.id),
              color: fill(swatch.hex),
              selected: !isLogo && !isCustom && _same(current, swatch.hex),
              onTap: tap(() => onSelected(swatch.hex)),
            ),
        ],
      ),
    );
  }

  static Gradient _rainbow(Color Function(String) fill) => SweepGradient(
    colors: [
      for (var h = 0; h <= 360; h += 60)
        fill(HexColor.fromHsl(h * 1.0, 0.75, 0.55)),
    ],
  );
}
