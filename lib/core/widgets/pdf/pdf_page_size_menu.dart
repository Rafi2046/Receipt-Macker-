import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../services/pdf/pdf_page_size.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'pdf_template_labels.dart';

/// Compact paper-size popup used on the PDF options bar.
class PdfPageSizeMenu extends StatelessWidget {
  const PdfPageSizeMenu({
    required this.pageSize,
    required this.onSelected,
    super.key,
  });

  final PdfPageSize pageSize;
  final ValueChanged<PdfPageSize>? onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopupMenuButton<PdfPageSize>(
      tooltip: l10n.pdfPageSizeLabel,
      enabled: onSelected != null,
      initialValue: pageSize,
      onSelected: onSelected,
      itemBuilder: (context) => [
        for (final size in PdfPageSize.values)
          PopupMenuItem(value: size, child: Text(l10n.pageSizeName(size))),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.xs,
          children: [
            Icon(
              AppIcons.pageSize,
              size: AppSizes.iconSm,
              color: context.appColors.primary,
            ),
            Text(
              l10n.pageSizeName(pageSize),
              style: context.textStyles.labelLarge?.copyWith(
                color: context.appColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
