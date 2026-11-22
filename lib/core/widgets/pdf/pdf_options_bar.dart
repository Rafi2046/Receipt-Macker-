import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/pdf_page_size.dart';
import '../../services/pdf/pdf_template.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'accent_color_row.dart';
import 'pdf_template_labels.dart';

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
    this.logoAccentHex,
    this.pageSize = PdfPageSize.a4,
    this.onPageSize,
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

  /// The logo's main color, offered first in the color row.
  final String? logoAccentHex;
  final PdfPageSize pageSize;

  /// Shows the paper size choice when set.
  final ValueChanged<PdfPageSize>? onPageSize;
  final bool enabled;

  static String _templateName(AppLocalizations l10n, PdfTemplate template) {
    final name = l10n.templateName(template);
    if (!template.requiresPro) return name;
    return '$name · ${l10n.templateProBadge}';
  }

  static const String _en = 'en';
  static const String _bn = 'bn';

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
                  icon: const Icon(AppIcons.palette, size: 16),
                  label: Text(l10n.templateStudioAction),
                  onPressed: enabled ? onOpenStudio : null,
                ),
              if (onPageSize case final onPageSize?)
                _PageSizeMenu(
                  pageSize: pageSize,
                  onSelected: enabled ? onPageSize : null,
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
          if (onAccentColor case final onAccent?)
            AccentColorRow(
              selectedHex: brandAccentColor,
              template: template,
              logoHex: logoAccentHex,
              enabled: enabled,
              onSelected: onAccent,
            ),
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

/// The paper size as a compact menu button, so the bar stays short.
class _PageSizeMenu extends StatelessWidget {
  const _PageSizeMenu({required this.pageSize, required this.onSelected});

  final PdfPageSize pageSize;
  final ValueChanged<PdfPageSize>? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<PdfPageSize>(
      tooltip: l10n.pdfPageSizeLabel,
      enabled: onSelected != null,
      initialValue: pageSize,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final size in PdfPageSize.values)
          PopupMenuItem(value: size, child: Text(l10n.pageSizeName(size))),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Icon(
              AppIcons.pageSize,
              size: AppSizes.iconSm,
              color: context.appColors.primary,
            ),
            Text(
              l10n.pageSizeName(pageSize),
              style: context.textStyles.labelLarge?.copyWith(
                color: context.appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
