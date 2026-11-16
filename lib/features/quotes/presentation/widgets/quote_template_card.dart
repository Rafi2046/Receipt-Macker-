import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/pdf/brand_swatch.dart';
import '../../../../core/services/pdf/pdf_template.dart';
import '../../../../core/services/pdf/pdf_template_catalog.dart';
import '../../../../core/services/pdf/pdf_template_catalog_entry.dart';
import '../../../../core/services/purchases/purchase_providers.dart';
import '../../../../core/services/service_providers.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/pdf/mini_layout_thumbnail.dart';
import '../../../../core/widgets/pdf/template_catalog_picker.dart';

/// Opens the shared template catalog; selection is stored in app prefs.
class QuoteTemplateCard extends ConsumerStatefulWidget {
  const QuoteTemplateCard({super.key});

  @override
  ConsumerState<QuoteTemplateCard> createState() => _QuoteTemplateCardState();
}

class _QuoteTemplateCardState extends ConsumerState<QuoteTemplateCard> {
  PdfTemplateCatalogEntry? _entry;

  Color _accent(String hex) {
    final clean = hex.replaceAll('#', '');
    final val = int.tryParse(clean, radix: 16) ?? 0xFF5738;
    return Color(0xFF000000 | val);
  }

  PdfTemplateCatalogEntry _resolved() {
    if (_entry != null) return _entry!;
    final prefs = ref.read(appPreferencesProvider);
    return PdfTemplateCatalog.resolve(
      layout: PdfTemplate.fromId(prefs.pdfTemplate),
      accentHex: prefs.brandAccentColor ?? BrandSwatch.coral.hex,
    );
  }

  Future<void> _open() async {
    final prefs = ref.read(appPreferencesProvider);
    final isPro = ref.read(proStatusProvider);
    final current = _resolved();
    final entry = await TemplateCatalogPicker.open(
      context,
      selectedLayout: current.layout,
      selectedAccentHex: current.accentHex,
      isPro: isPro,
    );
    if (entry == null || !mounted) return;
    await prefs.setPdfTemplate(entry.layout.id);
    await prefs.setBrandAccentColor(entry.accentHex);
    setState(() => _entry = entry);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final entry = _resolved();

    return AppCard(
      onTap: _open,
      child: Row(
        children: [
          Icon(AppIcons.business, color: colors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l10n.quoteTemplates,
              style: context.textStyles.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          MiniLayoutThumbnail(
            template: entry.layout,
            accentColor: _accent(entry.accentHex),
            width: 44,
            height: 58,
          ),
          const SizedBox(width: AppSpacing.sm),
          Icon(AppIcons.chevronRight, color: colors.textSecondary),
        ],
      ),
    );
  }
}
