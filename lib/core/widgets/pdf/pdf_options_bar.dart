import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/pdf_template.dart';
import '../../utils/extensions/l10n_extension.dart';

/// Template and language choice above a PDF preview. Disabled while a PDF
/// is being made.
class PdfOptionsBar extends StatelessWidget {
  const PdfOptionsBar({
    required this.template,
    required this.languageCode,
    required this.onTemplate,
    required this.onLanguage,
    this.enabled = true,
    super.key,
  });

  final PdfTemplate template;
  final String languageCode;
  final ValueChanged<PdfTemplate> onTemplate;
  final ValueChanged<String> onLanguage;
  final bool enabled;

  static String _templateName(AppLocalizations l10n, PdfTemplate template) {
    final name = switch (template) {
      PdfTemplate.classic => l10n.templateClassic,
      PdfTemplate.modern => l10n.templateModern,
      PdfTemplate.minimal => l10n.templateMinimal,
    };
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
          Text(l10n.pdfTemplateLabel, style: label),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              for (final t in PdfTemplate.values)
                ChoiceChip(
                  label: Text(_templateName(l10n, t)),
                  selected: t == template,
                  onSelected: enabled ? (_) => onTemplate(t) : null,
                ),
            ],
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
