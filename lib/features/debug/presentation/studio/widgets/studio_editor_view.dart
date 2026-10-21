import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../../core/utils/formatters.dart';
import '../studio_demo.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import 'studio_avatar.dart';
import 'studio_card.dart';
import 'studio_editor_sections.dart';
import 'studio_editor_summary.dart';
import 'studio_page_header.dart';

/// Sectioned invoice editor with a sticky total bar.
class StudioEditorView extends StatelessWidget {
  const StudioEditorView({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ColoredBox(
      color: context.studio.background,
      child: Column(
        children: [
          StudioPageHeader(title: l10n.invoiceNewTitle, onBack: onBack),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                AppSpacing.lg,
              ),
              children: const [
                _ClientCard(),
                SizedBox(height: AppSpacing.md),
                _DatesCard(),
                SizedBox(height: AppSpacing.md),
                StudioEditorSections(),
              ],
            ),
          ),
          const StudioEditorSummary(),
        ],
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  const _ClientCard();

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final l10n = context.l10n;
    final phone = studioFormat(context).localizeDigits(StudioDemo.editorPhone);
    return StudioCard(
      child: Row(
        children: [
          const StudioAvatar(name: StudioDemo.editorClient),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StudioDemo.editorClient,
                  style: context.studioType.titleSm(palette.ink),
                ),
                Text(phone, style: context.studioType.secondary(palette.muted)),
              ],
            ),
          ),
          TextButton(onPressed: () {}, child: Text(l10n.studioChangeClient)),
        ],
      ),
    );
  }
}

class _DatesCard extends StatelessWidget {
  const _DatesCard();

  @override
  Widget build(BuildContext context) {
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return Row(
      children: [
        Expanded(
          child: _DateTile(
            label: context.l10n.fieldIssueDate,
            value: format.date(DateTime(2026, 10, 21)),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _DateTile(
            label: context.l10n.fieldDueDate,
            value: format.date(DateTime(2026, 11, 4)),
          ),
        ),
      ],
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return StudioCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.studioType.label(palette.muted)),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: context.studioType.titleSm(palette.ink)),
        ],
      ),
    );
  }
}
