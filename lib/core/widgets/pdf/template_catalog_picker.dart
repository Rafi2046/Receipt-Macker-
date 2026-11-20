import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/pdf_template.dart';
import '../../services/pdf/pdf_template_catalog.dart';
import '../../services/pdf/pdf_template_catalog_entry.dart';
import '../../services/pdf/pdf_template_category.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../layout/app_scaffold.dart';
import 'mini_layout_thumbnail.dart';
import 'pdf_template_labels.dart';

/// Full-screen category grid for picking a layout + accent catalog entry.
class TemplateCatalogPicker extends StatefulWidget {
  const TemplateCatalogPicker({
    required this.selectedLayout,
    required this.selectedAccentHex,
    required this.isPro,
    super.key,
  });

  final PdfTemplate selectedLayout;
  final String? selectedAccentHex;
  final bool isPro;

  /// Opens the picker. Returns the chosen entry, or null if cancelled.
  static Future<PdfTemplateCatalogEntry?> open(
    BuildContext context, {
    required PdfTemplate selectedLayout,
    required String? selectedAccentHex,
    required bool isPro,
  }) {
    return Navigator.of(context).push<PdfTemplateCatalogEntry>(
      MaterialPageRoute(
        builder: (_) => TemplateCatalogPicker(
          selectedLayout: selectedLayout,
          selectedAccentHex: selectedAccentHex,
          isPro: isPro,
        ),
      ),
    );
  }

  @override
  State<TemplateCatalogPicker> createState() => _TemplateCatalogPickerState();
}

class _TemplateCatalogPickerState extends State<TemplateCatalogPicker> {
  late PdfTemplateCategory _category;
  late PdfTemplateCatalogEntry _draft;

  @override
  void initState() {
    super.initState();
    _draft = PdfTemplateCatalog.resolve(
      layout: widget.selectedLayout,
      accentHex: widget.selectedAccentHex,
    );
    _category = _draft.category;
  }

  Color _accentColor(String hex) {
    final clean = hex.replaceAll('#', '');
    final val = int.tryParse(clean, radix: 16) ?? 0xFF5738;
    return Color(0xFF000000 | val);
  }

  Future<void> _onTap(PdfTemplateCatalogEntry entry) async {
    if (entry.requiresPro && !widget.isPro) {
      await context.pushNamed(RouteNames.paywall);
      return;
    }
    setState(() => _draft = entry);
  }

  void _save() => Navigator.of(context).pop(_draft);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final items = PdfTemplateCatalog.byCategory(_category);

    return AppScaffold(
      title: l10n.templateCatalogTitle,
      actions: [
        TextButton(
          onPressed: _save,
          child: Text(
            l10n.save,
            style: context.textStyles.labelLarge?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pagePadding,
              ),
              itemCount: PdfTemplateCategory.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final cat = PdfTemplateCategory.values[index];
                final selected = cat == _category;
                return ChoiceChip(
                  label: Text(l10n.templateCategoryName(cat)),
                  selected: selected,
                  onSelected: (_) => setState(() => _category = cat),
                  selectedColor: colors.primary.withValues(alpha: 0.15),
                  labelStyle: context.textStyles.labelLarge?.copyWith(
                    color: selected ? colors.primary : colors.textSecondary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: selected ? colors.primary : colors.border,
                  ),
                  backgroundColor: colors.surface,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: GridView.builder(
              // A new tab starts at its top, not at the last scroll offset.
              key: ValueKey(_category),
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                0,
                AppSpacing.pagePadding,
                AppSpacing.xxxl,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.64,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final entry = items[index];
                final selected = entry.id == _draft.id;
                final locked = entry.requiresPro && !widget.isPro;
                final accent = _accentColor(entry.accentHex);
                return _CatalogTile(
                  title:
                      '${l10n.templateName(entry.layout)} · '
                      '${l10n.swatchName(entry.swatch.id)}',
                  selected: selected,
                  locked: locked,
                  proBadge: entry.requiresPro,
                  accent: accent,
                  layout: entry.layout,
                  onTap: () => _onTap(entry),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({
    required this.title,
    required this.selected,
    required this.locked,
    required this.proBadge,
    required this.accent,
    required this.layout,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final bool locked;
  final bool proBadge;
  final Color accent;
  final PdfTemplate layout;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    return Material(
      color: colors.surface,
      elevation: selected ? 2 : 1,
      shadowColor: colors.textPrimary.withValues(alpha: 0.18),
      borderRadius: AppRadius.card,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.card,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppRadius.card,
            border: Border.all(
              color: selected ? colors.primary : colors.border,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.sm,
                    AppSpacing.sm,
                    AppSpacing.sm,
                    0,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return MiniLayoutThumbnail(
                            template: layout,
                            accentColor: accent,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            framed: false,
                          );
                        },
                      ),
                      if (proBadge)
                        Positioned(
                          top: AppSpacing.xs,
                          right: AppSpacing.xs,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colors.secondary,
                              borderRadius: AppRadius.chip,
                            ),
                            child: Text(
                              l10n.templateProBadge,
                              style: context.textStyles.labelSmall?.copyWith(
                                color: colors.onSecondary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      if (locked)
                        Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.textPrimary.withValues(alpha: 0.28),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(AppIcons.lock, color: colors.surface),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.sm,
                  AppSpacing.md,
                ),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.textStyles.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
