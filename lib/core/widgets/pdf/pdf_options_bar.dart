import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/pdf_page_size.dart';
import '../../services/pdf/pdf_template.dart';
import '../../services/pdf/stamp_placement.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'accent_color_row.dart';
import 'pdf_page_size_menu.dart';
import 'pdf_template_labels.dart';
import 'stamp_placement_row.dart';

/// Compact template / accent / language toolbar above a PDF preview.
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
    this.stampPlacement,
    this.onStampPlacement,
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

  /// Invoice status stamp position; omitted on quotes/receipts.
  final StampPlacement? stampPlacement;
  final ValueChanged<StampPlacement>? onStampPlacement;
  final bool enabled;

  static String templateLabel(AppLocalizations l10n, PdfTemplate template) {
    final name = l10n.templateName(template);
    if (!template.requiresPro) return name;
    return '$name · ${l10n.templateProBadge}';
  }

  static const String _en = 'en';
  static const String _bn = 'bn';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.sm,
        AppSpacing.pagePadding,
        AppSpacing.sm,
      ),
      child: Material(
        color: colors.surface,
        borderRadius: AppRadius.card,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.sm,
            children: [
              _TemplateSummary(
                template: template,
                enabled: enabled,
                onOpenStudio: onOpenStudio,
                onTemplate: onTemplate,
              ),
              if (onAccentColor case final onAccent?)
                AccentColorRow(
                  selectedHex: brandAccentColor,
                  template: template,
                  logoHex: logoAccentHex,
                  enabled: enabled,
                  onSelected: onAccent,
                ),
              _LanguageAndSize(
                languageCode: languageCode,
                enabled: enabled,
                onLanguage: onLanguage,
                pageSize: pageSize,
                onPageSize: onPageSize,
                stampPlacement: stampPlacement,
                onStampPlacement: onStampPlacement,
                en: _en,
                bn: _bn,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TemplateSummary extends StatelessWidget {
  const _TemplateSummary({
    required this.template,
    required this.enabled,
    required this.onTemplate,
    this.onOpenStudio,
  });

  final PdfTemplate template;
  final bool enabled;
  final VoidCallback? onOpenStudio;
  final ValueChanged<PdfTemplate> onTemplate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final label = PdfOptionsBar.templateLabel(l10n, template);
    final openStudio = onOpenStudio;

    if (openStudio != null) {
      return Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: enabled ? openStudio : null,
              borderRadius: AppRadius.input,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              foregroundColor: colors.primary,
            ),
            icon: const Icon(AppIcons.palette, size: AppSizes.iconSm),
            label: Text(l10n.templateStudioAction),
            onPressed: enabled ? openStudio : null,
          ),
        ],
      );
    }

    return PopupMenuButton<PdfTemplate>(
      enabled: enabled,
      initialValue: template,
      tooltip: l10n.pdfTemplateLabel,
      onSelected: onTemplate,
      itemBuilder: (context) => [
        for (final t in PdfTemplate.values)
          PopupMenuItem(
            value: t,
            child: Text(PdfOptionsBar.templateLabel(l10n, t)),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              AppIcons.dropdown,
              size: AppSizes.iconSm,
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageAndSize extends StatelessWidget {
  const _LanguageAndSize({
    required this.languageCode,
    required this.enabled,
    required this.onLanguage,
    required this.pageSize,
    required this.en,
    required this.bn,
    this.onPageSize,
    this.stampPlacement,
    this.onStampPlacement,
  });

  final String languageCode;
  final bool enabled;
  final ValueChanged<String> onLanguage;
  final PdfPageSize pageSize;
  final ValueChanged<PdfPageSize>? onPageSize;
  final StampPlacement? stampPlacement;
  final ValueChanged<StampPlacement>? onStampPlacement;
  final String en;
  final String bn;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: SegmentedButton<String>(
            segments: [
              ButtonSegment(value: en, label: Text(l10n.languageEnglish)),
              ButtonSegment(value: bn, label: Text(l10n.languageBangla)),
            ],
            selected: {languageCode == bn ? bn : en},
            onSelectionChanged: enabled
                ? (next) {
                    if (next.isEmpty) return;
                    onLanguage(next.first);
                  }
                : null,
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
        if (stampPlacement case final placement?
            when onStampPlacement != null)
          StampPlacementRow(
            placement: placement,
            enabled: enabled,
            onSelected: onStampPlacement!,
          ),
        if (onPageSize case final onSize?)
          PdfPageSizeMenu(
            pageSize: pageSize,
            onSelected: enabled ? onSize : null,
          ),
      ],
    );
  }
}
