import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/brand_swatch.dart';
import '../../services/pdf/pdf_template.dart';
import '../../services/pdf/pdf_template_catalog.dart';
import '../../services/pdf/pdf_template_catalog_entry.dart';
import '../../services/purchases/purchase_providers.dart';
import '../../services/service_providers.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../layout/app_card.dart';
import 'mini_layout_thumbnail.dart';
import 'template_catalog_picker.dart';

/// A "Templates" row showing the current PDF design; opens the template
/// catalog. The choice is stored in app preferences (one for every
/// document).
class TemplatePickerCard extends ConsumerStatefulWidget {
  const TemplatePickerCard({super.key});

  @override
  ConsumerState<TemplatePickerCard> createState() => _TemplatePickerCardState();
}

class _TemplatePickerCardState extends ConsumerState<TemplatePickerCard> {
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
          Icon(AppIcons.template, color: colors.textPrimary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              l10n.editorTemplates,
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
