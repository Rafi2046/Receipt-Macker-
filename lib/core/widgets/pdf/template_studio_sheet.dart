import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/brand_swatch.dart';
import '../../services/pdf/pdf_template.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../buttons/app_button.dart';

enum _TemplateFilter { all, free, pro }

/// Modal bottom sheet for browsing, filtering, and customizing PDF templates
/// and brand accent colors.
class TemplateStudioSheet extends StatefulWidget {
  const TemplateStudioSheet({
    required this.selectedTemplate,
    required this.selectedAccentHex,
    required this.isPro,
    required this.onSelectTemplate,
    required this.onSelectAccentHex,
    super.key,
  });

  final PdfTemplate selectedTemplate;
  final String? selectedAccentHex;
  final bool isPro;
  final ValueChanged<PdfTemplate> onSelectTemplate;
  final ValueChanged<String> onSelectAccentHex;

  static Future<void> show(
    BuildContext context, {
    required PdfTemplate selectedTemplate,
    required String? selectedAccentHex,
    required bool isPro,
    required ValueChanged<PdfTemplate> onSelectTemplate,
    required ValueChanged<String> onSelectAccentHex,
  }) => showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => TemplateStudioSheet(
      selectedTemplate: selectedTemplate,
      selectedAccentHex: selectedAccentHex,
      isPro: isPro,
      onSelectTemplate: onSelectTemplate,
      onSelectAccentHex: onSelectAccentHex,
    ),
  );

  @override
  State<TemplateStudioSheet> createState() => _TemplateStudioSheetState();
}

class _TemplateStudioSheetState extends State<TemplateStudioSheet> {
  _TemplateFilter _filter = _TemplateFilter.all;
  late String _currentHex;

  @override
  void initState() {
    super.initState();
    _currentHex = widget.selectedAccentHex ?? BrandSwatch.emerald.hex;
  }

  Color _parseHex(String hex) {
    final clean = hex.replaceAll('#', '');
    final val = int.tryParse(clean, radix: 16) ?? 0x006A4E;
    return Color(0xFF000000 | val);
  }

  String _templateName(AppLocalizations l10n, PdfTemplate t) => switch (t) {
    PdfTemplate.classic => l10n.templateClassic,
    PdfTemplate.minimal => l10n.templateMinimal,
    PdfTemplate.modern => l10n.templateModern,
    PdfTemplate.executive => l10n.templateExecutive,
    PdfTemplate.studio => l10n.templateStudio,
    PdfTemplate.editorial => l10n.templateEditorial,
    PdfTemplate.compact => l10n.templateCompact,
    PdfTemplate.ledger => l10n.templateLedger,
  };

  String _templateDesc(AppLocalizations l10n, PdfTemplate t) => switch (t) {
    PdfTemplate.classic => l10n.templateClassicDesc,
    PdfTemplate.minimal => l10n.templateMinimalDesc,
    PdfTemplate.modern => l10n.templateModernDesc,
    PdfTemplate.executive => l10n.templateExecutiveDesc,
    PdfTemplate.studio => l10n.templateStudioDesc,
    PdfTemplate.editorial => l10n.templateEditorialDesc,
    PdfTemplate.compact => l10n.templateCompactDesc,
    PdfTemplate.ledger => l10n.templateLedgerDesc,
  };

  String _swatchName(AppLocalizations l10n, String id) => switch (id) {
    'emerald' => l10n.swatchEmerald,
    'navy' => l10n.swatchNavy,
    'crimson' => l10n.swatchCrimson,
    'slate' => l10n.swatchSlate,
    'amber' => l10n.swatchAmber,
    'teal' => l10n.swatchTeal,
    'indigo' => l10n.swatchIndigo,
    'charcoal' => l10n.swatchCharcoal,
    _ => id,
  };

  List<PdfTemplate> get _filteredTemplates {
    return PdfTemplate.values.where((t) {
      return switch (_filter) {
        _TemplateFilter.all => true,
        _TemplateFilter.free => !t.requiresPro,
        _TemplateFilter.pro => t.requiresPro,
      };
    }).toList();
  }

  void _onTemplateTapped(PdfTemplate t) {
    if (t.requiresPro && !widget.isPro) {
      context.pushNamed(RouteNames.paywall);
      return;
    }
    widget.onSelectTemplate(t);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final activeColor = _parseHex(_currentHex);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle & Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
                0,
              ),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.templateStudioTitle,
                              style: context.textStyles.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              l10n.templateStudioSubtitle,
                              style: context.textStyles.bodySmall?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(AppIcons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),

            // Scrollable Content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.pagePadding,
                  vertical: AppSpacing.sm,
                ),
                children: [
                  // Brand Color Section
                  Text(
                    l10n.templateBrandColorLabel,
                    style: context.textStyles.labelLarge?.copyWith(
                      color: colors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: BrandSwatch.values.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final swatch = BrandSwatch.values[index];
                        final swatchColor = _parseHex(swatch.hex);
                        final isSelected =
                            _currentHex.toLowerCase() ==
                            swatch.hex.toLowerCase();
                        return GestureDetector(
                          onTap: () {
                            setState(() => _currentHex = swatch.hex);
                            widget.onSelectAccentHex(swatch.hex);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: swatchColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? colors.surface
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: swatchColor.withValues(
                                              alpha: 0.5,
                                            ),
                                            blurRadius: 6,
                                            spreadRadius: 2,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 18,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _swatchName(l10n, swatch.id),
                                style: context.textStyles.labelSmall?.copyWith(
                                  fontSize: 10,
                                  color: isSelected
                                      ? swatchColor
                                      : colors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Filter Segmented Chips
                  Row(
                    children: [
                      _FilterChip(
                        label: '${l10n.templateFilterAll} (8)',
                        selected: _filter == _TemplateFilter.all,
                        onTap: () =>
                            setState(() => _filter = _TemplateFilter.all),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _FilterChip(
                        label: '${l10n.templateFilterFree} (1)',
                        selected: _filter == _TemplateFilter.free,
                        onTap: () =>
                            setState(() => _filter = _TemplateFilter.free),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      _FilterChip(
                        label: '${l10n.templateFilterPro} (7)',
                        selected: _filter == _TemplateFilter.pro,
                        onTap: () =>
                            setState(() => _filter = _TemplateFilter.pro),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Template Cards Grid / List
                  for (final t in _filteredTemplates) ...[
                    _TemplateCard(
                      template: t,
                      name: _templateName(l10n, t),
                      description: _templateDesc(l10n, t),
                      isSelected: t == widget.selectedTemplate,
                      isProUser: widget.isPro,
                      accentColor: activeColor,
                      onTap: () => _onTemplateTapped(t),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],

                  if (!widget.isPro) ...[
                    const SizedBox(height: AppSpacing.md),
                    _ProUnlockBanner(
                      onTap: () {
                        Navigator.of(context).pop();
                        context.pushNamed(RouteNames.paywall);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? colors.primary.withValues(alpha: 0.12)
              : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? colors.primary : colors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: context.textStyles.labelMedium?.copyWith(
            color: selected ? colors.primary : colors.textSecondary,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.name,
    required this.description,
    required this.isSelected,
    required this.isProUser,
    required this.accentColor,
    required this.onTap,
  });

  final PdfTemplate template;
  final String name;
  final String description;
  final bool isSelected;
  final bool isProUser;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final isLocked = template.requiresPro && !isProUser;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected
              ? colors.primary.withValues(alpha: 0.04)
              : colors.surfaceAlt,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Miniature Layout Thumbnail
            _MiniLayoutThumbnail(template: template, accentColor: accentColor),
            const SizedBox(width: AppSpacing.md),

            // Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: context.textStyles.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (template.requiresPro) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: colors.secondary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isLocked ? AppIcons.lock : AppIcons.proBadge,
                                size: 10,
                                color: colors.onSecondary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                l10n.templateProBadge,
                                style: context.textStyles.labelSmall?.copyWith(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: colors.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: colors.textSecondary,
                      fontSize: 11,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Selection indicator
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.white),
              )
            else if (isLocked)
              Icon(AppIcons.lock, size: 18, color: colors.textSecondary)
            else
              Icon(
                Icons.radio_button_unchecked,
                size: 18,
                color: colors.border,
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniLayoutThumbnail extends StatelessWidget {
  const _MiniLayoutThumbnail({
    required this.template,
    required this.accentColor,
  });

  final PdfTemplate template;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFD9DEE3), width: 0.8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(3),
      child: switch (template) {
        PdfTemplate.classic => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 14, height: 3, color: const Color(0xFF56606B)),
                Container(width: 16, height: 3, color: accentColor),
              ],
            ),
            const SizedBox(height: 3),
            Container(height: 1, color: accentColor),
            const SizedBox(height: 4),
            Container(height: 3, color: accentColor),
            const SizedBox(height: 2),
            Container(height: 1.5, color: const Color(0xFFE2E8F0)),
            const SizedBox(height: 2),
            Container(height: 1.5, color: const Color(0xFFE2E8F0)),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 20, height: 4, color: accentColor),
            ),
          ],
        ),
        PdfTemplate.minimal => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 12,
                  height: 2.5,
                  color: const Color(0xFF14181C),
                ),
                Container(
                  width: 12,
                  height: 2.5,
                  color: const Color(0xFF14181C),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Container(height: 0.8, color: const Color(0xFF14181C)),
            const SizedBox(height: 4),
            Container(height: 1.5, color: const Color(0xFF94A3B8)),
            const SizedBox(height: 2),
            Container(height: 1.5, color: const Color(0xFFCBD5E1)),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 18,
                height: 2.5,
                color: const Color(0xFF14181C),
              ),
            ),
          ],
        ),
        PdfTemplate.modern => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 2.5, color: accentColor),
            const SizedBox(height: 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 14, height: 4, color: const Color(0xFF14181C)),
                Container(
                  width: 12,
                  height: 2.5,
                  color: const Color(0xFF94A3B8),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    color: accentColor.withValues(alpha: 0.15),
                  ),
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Container(
                    height: 8,
                    color: accentColor.withValues(alpha: 0.15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Container(height: 2, color: const Color(0xFFF1F5F9)),
            const SizedBox(height: 1.5),
            Container(height: 2, color: Colors.white),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 18, height: 2, color: accentColor),
            ),
          ],
        ),
        PdfTemplate.executive => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 12,
              color: accentColor,
              padding: const EdgeInsets.all(1.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 12, height: 2, color: Colors.white),
                  Container(
                    width: 10,
                    height: 2,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
            Container(height: 1.2, color: const Color(0xFFE0A100)),
            const SizedBox(height: 3),
            Container(height: 2, color: const Color(0xFFE2E8F0)),
            const SizedBox(height: 2),
            Container(height: 2, color: const Color(0xFFE2E8F0)),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 20, height: 4, color: accentColor),
            ),
          ],
        ),
        PdfTemplate.studio => Row(
          children: [
            Container(width: 3.5, color: accentColor),
            const SizedBox(width: 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 10,
                    height: 2.5,
                    color: accentColor.withValues(alpha: 0.25),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 22,
                    height: 4,
                    color: const Color(0xFF14181C),
                  ),
                  const SizedBox(height: 4),
                  Container(height: 2, color: const Color(0xFFE2E8F0)),
                  const SizedBox(height: 2),
                  Container(height: 2, color: const Color(0xFFE2E8F0)),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 16,
                      height: 2.5,
                      color: accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        PdfTemplate.editorial => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: 1, color: accentColor),
            const SizedBox(height: 1),
            Container(height: 0.5, color: accentColor),
            const SizedBox(height: 3),
            Center(
              child: Container(
                width: 18,
                height: 3,
                color: const Color(0xFF14181C),
              ),
            ),
            const SizedBox(height: 3),
            Container(height: 0.5, color: const Color(0xFFCBD5E1)),
            const SizedBox(height: 3),
            Container(height: 1.5, color: const Color(0xFFE2E8F0)),
            const SizedBox(height: 2),
            Container(height: 1.5, color: const Color(0xFFE2E8F0)),
            const Spacer(),
            Container(height: 0.5, color: accentColor),
            const SizedBox(height: 1),
            Container(height: 1, color: accentColor),
          ],
        ),
        PdfTemplate.compact => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 16, height: 2.5, color: accentColor),
                Container(
                  width: 14,
                  height: 2.5,
                  color: const Color(0xFF14181C),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Container(height: 1, color: accentColor),
            const SizedBox(height: 1.5),
            Container(height: 1.5, color: accentColor),
            for (var i = 0; i < 4; i++) ...[
              const SizedBox(height: 1),
              Container(
                height: 1.5,
                color: i.isEven ? const Color(0xFFF1F5F9) : Colors.white,
              ),
            ],
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Container(width: 18, height: 3, color: accentColor),
            ),
          ],
        ),
        PdfTemplate.ledger => Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF94A3B8), width: 0.8),
          ),
          padding: const EdgeInsets.all(1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 8,
                      color: Colors.white,
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 2,
                          color: accentColor,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 0.8,
                    height: 8,
                    color: const Color(0xFF94A3B8),
                  ),
                  Expanded(
                    child: Container(
                      height: 8,
                      color: const Color(0xFFF1F5F9),
                      child: Center(
                        child: Container(
                          width: 8,
                          height: 2,
                          color: const Color(0xFF14181C),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(height: 0.8, color: const Color(0xFF94A3B8)),
              const SizedBox(height: 2),
              Container(height: 1.5, color: const Color(0xFFCBD5E1)),
              const SizedBox(height: 1.5),
              Container(height: 1.5, color: const Color(0xFFCBD5E1)),
              const Spacer(),
              Container(
                height: 4,
                color: accentColor.withValues(alpha: 0.2),
                child: Center(
                  child: Container(width: 14, height: 2, color: accentColor),
                ),
              ),
            ],
          ),
        ),
      },
    );
  }
}

class _ProUnlockBanner extends StatelessWidget {
  const _ProUnlockBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.primary.withValues(alpha: 0.08),
            colors.secondary.withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  AppIcons.proBadge,
                  size: 20,
                  color: colors.onSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.templateUnlockAllTitle,
                      style: context.textStyles.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.proSubtitle,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: colors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.templateUnlockAllCta,
            icon: AppIcons.proBadge,
            expand: true,
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}
