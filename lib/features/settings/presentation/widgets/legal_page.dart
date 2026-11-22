import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import 'legal_contact.dart';
import 'legal_hero.dart';
import 'legal_paragraph.dart';

/// A legal page read like a document: title, numbered paragraphs, contact.
class LegalPage extends StatelessWidget {
  const LegalPage({
    required this.title,
    required this.hero,
    required this.sections,
    super.key,
  });

  final String title;
  final LegalHero hero;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return AppScaffold(
      title: title,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSizes.fabClearance,
        ),
        children: [
          hero,
          const SizedBox(height: AppSpacing.lg),
          const Divider(),
          const SizedBox(height: AppSpacing.lg),
          for (var i = 0; i < sections.length; i++) ...[
            LegalParagraph(number: format.integer(i + 1), section: sections[i]),
            const SizedBox(height: AppSpacing.xl),
          ],
          const Divider(),
          const SizedBox(height: AppSpacing.lg),
          const LegalContact(),
        ],
      ),
    );
  }
}
