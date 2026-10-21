import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import '../widgets/studio_filter_chips.dart';
import '../widgets/studio_page_header.dart';
import 'bill_catalog.dart';
import 'bill_kinds.dart';
import 'bill_template.dart';
import 'bill_thumbnail.dart';

/// Category tabs and a thumbnail for every curated template.
class BillGalleryView extends StatefulWidget {
  const BillGalleryView({
    required this.onBack,
    required this.onOpen,
    required this.selectedId,
    super.key,
  });

  final VoidCallback onBack;
  final ValueChanged<BillTemplate> onOpen;
  final String? selectedId;

  @override
  State<BillGalleryView> createState() => _BillGalleryViewState();
}

class _BillGalleryViewState extends State<BillGalleryView> {
  BillCategory _category = BillCategory.recommended;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = [
      l10n.studioTplRecommended,
      l10n.studioTplSimple,
      l10n.studioTplClassic,
      l10n.studioTplProfessional,
      l10n.studioTplCreative,
    ];
    final templates = BillCatalog.inCategory(_category);
    return ColoredBox(
      color: context.studio.background,
      child: Column(
        children: [
          StudioPageHeader(
            title: l10n.studioInvoiceDesign,
            onBack: widget.onBack,
          ),
          Expanded(
            child: _Grid(
              labels: labels,
              category: _category,
              templates: templates,
              selectedId: widget.selectedId,
              onCategory: (index) =>
                  setState(() => _category = BillCategory.values[index]),
              onOpen: widget.onOpen,
            ),
          ),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.labels,
    required this.category,
    required this.templates,
    required this.selectedId,
    required this.onCategory,
    required this.onOpen,
  });

  final List<String> labels;
  final BillCategory category;
  final List<BillTemplate> templates;
  final String? selectedId;
  final ValueChanged<int> onCategory;
  final ValueChanged<BillTemplate> onOpen;

  @override
  Widget build(BuildContext context) {
    final format = studioFormat(context);
    final counts = [
      for (final kind in BillCategory.values)
        format.integer(BillCatalog.inCategory(kind).length),
    ];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pagePadding,
          ),
          child: StudioFilterChips(
            labels: labels,
            counts: counts,
            selected: category.index,
            onSelected: onCategory,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              0,
              AppSpacing.pagePadding,
              AppSizes.fabClearance,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.62,
            ),
            itemCount: templates.length,
            itemBuilder: (context, index) => _Card(
              template: templates[index],
              selected: templates[index].id == selectedId,
              onOpen: () => onOpen(templates[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.template,
    required this.selected,
    required this.onOpen,
  });

  final BillTemplate template;
  final bool selected;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return Material(
      color: palette.surface,
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(child: BillThumbnail(template: template)),
                    if (template.pro)
                      Positioned(
                        top: AppSpacing.xs,
                        right: AppSpacing.xs,
                        child: _ProBadge(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                template.name,
                style: context.studioType.label(
                  selected ? palette.accent : palette.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.gold,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        child: Text(
          context.l10n.studioTplPro,
          style: context.studioType.label(palette.goldInk),
        ),
      ),
    );
  }
}
