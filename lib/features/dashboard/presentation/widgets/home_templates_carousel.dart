import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/pdf/brand_swatch.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/pdf/pdf_template_catalog.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/services/service_providers.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/pdf/mini_layout_thumbnail.dart';
import '../../../../core/widgets/pdf/template_studio_sheet.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// Horizontal carousel of invoice templates (matching Inventix "Trending Templates").
class HomeTemplatesCarousel extends ConsumerWidget {
  const HomeTemplatesCarousel({super.key});

  static const int _carouselCount = 8;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final isPro = ref.watch(proStatusProvider);
    final prefs = ref.watch(appPreferencesProvider);
    final accentHex = prefs.brandAccentColor ?? BrandSwatch.coral.hex;
    final carousel = PdfTemplateCatalog.byCategory(
      PdfTemplateCatalog.entries.first.category,
    ).take(_carouselCount).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.xs,
          children: [
            Text(
              l10n.homeTrendingTemplates,
              style: context.textStyles.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _openStudio(context, ref, isPro, accentHex),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.homeViewAll,
                    style: context.textStyles.labelLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 16, color: colors.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: carousel.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final entry = carousel[index];
              final accent = _colorFromHex(entry.accentHex);
              return _CarouselCard(
                template: entry.layout,
                name: _templateName(l10n, entry.layout),
                isPro: isPro,
                accentColor: accent,
                showPro: entry.requiresPro,
                onTap: () => _openStudio(context, ref, isPro, accentHex),
              );
            },
          ),
        ),
      ],
    );
  }

  static Color _colorFromHex(String hex) {
    final clean = hex.replaceAll('#', '');
    final val = int.tryParse(clean, radix: 16) ?? 0xFF5738;
    return Color(0xFF000000 | val);
  }

  void _openStudio(
    BuildContext context,
    WidgetRef ref,
    bool isPro,
    String? accentHex,
  ) {
    final prefs = ref.read(appPreferencesProvider);
    TemplateStudioSheet.show(
      context,
      selectedTemplate: PdfTemplate.fromId(prefs.pdfTemplate),
      isPro: isPro,
      selectedAccentHex: accentHex,
      onSelectTemplate: (template) {
        prefs.setPdfTemplate(template.id);
      },
      onSelectAccentHex: prefs.setBrandAccentColor,
    );
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
    PdfTemplate.nordic => l10n.templateNordic,
    PdfTemplate.folio => l10n.templateFolio,
    PdfTemplate.atelier => l10n.templateAtelier,
    PdfTemplate.lumen => l10n.templateLumen,
  };
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.template,
    required this.name,
    required this.isPro,
    required this.accentColor,
    required this.showPro,
    required this.onTap,
  });

  final PdfTemplate template;
  final String name;
  final bool isPro;
  final Color accentColor;
  final bool showPro;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isLocked = showPro && !isPro;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: MiniLayoutThumbnail(
                      template: template,
                      accentColor: accentColor,
                      width: 72,
                      height: 102,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: context.textStyles.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (showPro)
              Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  isLocked ? AppIcons.lock : AppIcons.proBadge,
                  size: 14,
                  color: colors.secondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
