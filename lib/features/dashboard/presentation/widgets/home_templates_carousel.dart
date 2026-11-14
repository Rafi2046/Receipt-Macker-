import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/pdf/brand_swatch.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/services/service_providers.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/pdf/mini_layout_thumbnail.dart';
import '../../../../core/widgets/pdf/template_studio_sheet.dart';
import '../../../../l10n/gen/app_localizations.dart';

/// Horizontal carousel of invoice templates (matching Inventix "Trending Templates").
class HomeTemplatesCarousel extends ConsumerWidget {
  const HomeTemplatesCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final isPro = ref.watch(proStatusProvider);
    final prefs = ref.watch(appPreferencesProvider);
    final accentHex = prefs.brandAccentColor ?? BrandSwatch.coral.hex;
    final cleanHex = accentHex.replaceAll('#', '');
    final val = int.tryParse(cleanHex, radix: 16) ?? 0xFF5738;
    final accentColor = Color(0xFF000000 | val);

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
                    style: TextStyle(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.chevron_right, size: 16, color: colors.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        SizedBox(
          height: 124,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: PdfTemplate.values.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final template = PdfTemplate.values[index];
              return _CarouselCard(
                template: template,
                name: _templateName(l10n, template),
                isPro: isPro,
                accentColor: accentColor,
                onTap: () => _openStudio(context, ref, isPro, accentHex),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openStudio(
    BuildContext context,
    WidgetRef ref,
    bool isPro,
    String? accentHex,
  ) {
    TemplateStudioSheet.show(
      context,
      selectedTemplate: PdfTemplate.classic,
      isPro: isPro,
      selectedAccentHex: accentHex,
      onSelectTemplate: (_) {},
      onSelectAccentHex: (hex) {
        ref.read(appPreferencesProvider).setBrandAccentColor(hex);
      },
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
  };
}

class _CarouselCard extends StatelessWidget {
  const _CarouselCard({
    required this.template,
    required this.name,
    required this.isPro,
    required this.accentColor,
    required this.onTap,
  });

  final PdfTemplate template;
  final String name;
  final bool isPro;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isLocked = template.requiresPro && !isPro;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 104,
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: MiniLayoutThumbnail(
                  template: template,
                  accentColor: accentColor,
                  width: 44,
                  height: 56,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                    ),
                  ),
                ),
                if (template.requiresPro) ...[
                  const SizedBox(width: 3),
                  Icon(
                    isLocked ? AppIcons.lock : AppIcons.proBadge,
                    size: 11,
                    color: colors.secondary,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
