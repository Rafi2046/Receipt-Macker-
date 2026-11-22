import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../services/ads/ad_providers.dart';
import '../../services/pdf/brand_swatch.dart';
import '../../services/pdf/pdf_template.dart';
import '../../services/purchases/purchase_providers.dart';
import '../../utils/color_from_hex.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../../utils/hex_color.dart';
import 'accent_dot.dart';
import 'custom_color_sheet.dart';
import 'pdf_template_labels.dart';
import 'pro_gate_sheet.dart';

/// The invoice color choice: the logo's color (when there is a logo), a
/// custom color, then the curated swatches. The swatches are free; the logo
/// and custom colors are Pro, or unlocked once by a rewarded ad.
class AccentColorRow extends ConsumerWidget {
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

  /// True when the user may pick a Pro color now: Pro, or just watched an ad.
  Future<bool> _unlock(BuildContext context, WidgetRef ref) async {
    if (ref.read(proStatusProvider)) return true;
    return ProGateSheet.show(
      context,
      title: context.l10n.colorProTitle,
      body: context.l10n.colorProBody,
      watchAd: ref.read(rewardedAdPresenterProvider).showForReward,
    );
  }

  Future<void> _pickLogo(
    BuildContext context,
    WidgetRef ref,
    String hex,
  ) async {
    if (await _unlock(context, ref)) onSelected(hex);
  }

  Future<void> _custom(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    if (!await _unlock(context, ref) || !context.mounted) return;
    final hex = await CustomColorSheet.show(
      context,
      initialHex: current,
      template: template,
    );
    if (hex != null) onSelected(hex);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final locked = !ref.watch(proStatusProvider);
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
              badge: locked ? AppIcons.lock : AppIcons.logoColor,
              onTap: tap(() => _pickLogo(context, ref, logo)),
            ),
          AccentDot(
            label: l10n.accentCustomColor,
            color: isCustom ? fill(current) : null,
            gradient: isCustom ? null : _rainbow(fill),
            selected: isCustom,
            centerIcon: AppIcons.add,
            badge: locked ? AppIcons.lock : (isCustom ? AppIcons.edit : null),
            onTap: tap(() => _custom(context, ref, current)),
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
