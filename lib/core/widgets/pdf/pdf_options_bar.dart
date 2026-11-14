import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/brand_swatch.dart';
import '../../services/pdf/pdf_template.dart';
import '../../utils/extensions/l10n_extension.dart';

/// Template, color accent and language choice above a PDF preview.
class PdfOptionsBar extends StatelessWidget {
  const PdfOptionsBar({
    required this.template,
    required this.languageCode,
    required this.onTemplate,
    required this.onLanguage,
    this.onOpenStudio,
    this.onAccentColor,
    this.brandAccentColor,
    this.enabled = true,
    super.key,
  });

  final PdfTemplate template;
  final String languageCode;
  final ValueChanged<PdfTemplate> onTemplate;
  final ValueChanged<String> onLanguage;
  final VoidCallback? onOpenStudio;
  final ValueChanged<String>? onAccentColor;
  final String? brandAccentColor;
  final bool enabled;

  static String _templateName(AppLocalizations l10n, PdfTemplate template) {
    final name = switch (template) {
      PdfTemplate.classic => l10n.templateClassic,
      PdfTemplate.minimal => l10n.templateMinimal,
      PdfTemplate.modern => l10n.templateModern,
      PdfTemplate.executive => l10n.templateExecutive,
      PdfTemplate.studio => l10n.templateStudio,
      PdfTemplate.editorial => l10n.templateEditorial,
      PdfTemplate.compact => l10n.templateCompact,
      PdfTemplate.ledger => l10n.templateLedger,
    };
    if (!template.requiresPro) return name;
    return '$name · ${l10n.templateProBadge}';
  }

  static const String _en = 'en';
  static const String _bn = 'bn';

  static Color _colorFromHex(String hex) {
    final clean = hex.replaceAll('#', '');
    final val = int.tryParse(clean, radix: 16) ?? 0xFF5738;
    return Color(0xFF000000 | val);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final label = context.textStyles.labelLarge?.copyWith(
      color: context.appColors.textSecondary,
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.sm,
        AppSpacing.pagePadding,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xs,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              Text(l10n.pdfTemplateLabel, style: label),
              if (onOpenStudio != null)
                TextButton.icon(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                  icon: const Icon(Icons.palette_outlined, size: 16),
                  label: Text(l10n.templateStudioAction),
                  onPressed: enabled ? onOpenStudio : null,
                ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final t in PdfTemplate.values) ...[
                  ChoiceChip(
                    label: Text(_templateName(l10n, t)),
                    selected: t == template,
                    onSelected: enabled ? (_) => onTemplate(t) : null,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
              ],
            ),
          ),
          if (onAccentColor != null) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final swatch in BrandSwatch.values) ...[
                    GestureDetector(
                      onTap: enabled ? () => onAccentColor!(swatch.hex) : null,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: _colorFromHex(swatch.hex),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                (brandAccentColor ?? BrandSwatch.coral.hex)
                                        .toLowerCase() ==
                                    swatch.hex.toLowerCase()
                                ? context.appColors.textPrimary
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                  ],
                ],
              ),
            ),
          ],
          Text(l10n.pdfLanguageLabel, style: label),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final (code, name) in [
                (_en, l10n.languageEnglish),
                (_bn, l10n.languageBangla),
              ])
                ChoiceChip(
                  label: Text(name),
                  selected: code == languageCode,
                  onSelected: enabled ? (_) => onLanguage(code) : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
