import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/brand_swatch.dart';
import '../../services/pdf/pdf_template.dart';
import '../../services/purchases/purchase_providers.dart';
import '../../services/purchases/template_choice.dart';
import '../../services/service_providers.dart';
import '../../utils/color_from_hex.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../layout/app_card.dart';
import '../layout/app_divider.dart';
import 'accent_color_row.dart';
import 'mini_layout_thumbnail.dart';
import 'pdf_template_labels.dart';
import 'template_catalog_picker.dart';

/// The document design in an editor: the current template (opens the
/// catalog) and the invoice color right under it. Both are stored in app
/// preferences, so they apply to every document.
class TemplatePickerCard extends ConsumerStatefulWidget {
  const TemplatePickerCard({this.logoAccentHex, super.key});

  /// The logo's main color, offered first in the color row.
  final String? logoAccentHex;

  @override
  ConsumerState<TemplatePickerCard> createState() => _TemplatePickerCardState();
}

class _TemplatePickerCardState extends ConsumerState<TemplatePickerCard> {
  late PdfTemplate _layout;
  late String _accentHex;

  @override
  void initState() {
    super.initState();
    final prefs = ref.read(appPreferencesProvider);
    _layout = PdfTemplate.fromId(prefs.pdfTemplate);
    _accentHex = prefs.brandAccentColor ?? BrandSwatch.coral.hex;
  }

  Future<void> _openCatalog() async {
    final prefs = ref.read(appPreferencesProvider);
    final entry = await TemplateCatalogPicker.open(
      context,
      selectedLayout: _layout,
      selectedAccentHex: _accentHex,
      isPro: ref.read(proStatusProvider),
    );
    if (entry == null || !mounted) return;
    await TemplateChoice.remember(prefs, entry.layout);
    await prefs.setBrandAccentColor(entry.accentHex);
    setState(() {
      _layout = entry.layout;
      _accentHex = entry.accentHex;
    });
  }

  Future<void> _setAccent(String hex) async {
    setState(() => _accentHex = hex);
    await ref.read(appPreferencesProvider).setBrandAccentColor(hex);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: _openCatalog,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.md),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Icon(AppIcons.template, color: colors.textPrimary),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _Title(
                      title: l10n.editorTemplates,
                      subtitle: l10n.templateName(_layout),
                    ),
                  ),
                  MiniLayoutThumbnail(
                    template: _layout,
                    accentColor: colorFromHex(
                      _accentHex,
                      fallback: colors.primary,
                    ),
                    width: 44,
                    height: 58,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Icon(AppIcons.chevronRight, color: colors.textSecondary),
                ],
              ),
            ),
          ),
          const AppDivider(spacing: 0),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
            ),
            child: Row(
              children: [
                Icon(AppIcons.palette, color: colors.textPrimary),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _Title(
                    title: l10n.accentColorTitle,
                    subtitle: l10n.accentColorHint,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              0,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: AccentColorRow(
              selectedHex: _accentHex,
              template: _layout,
              logoHex: widget.logoAccentHex,
              onSelected: _setAccent,
            ),
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textStyles.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          style: context.textStyles.bodySmall?.copyWith(
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
