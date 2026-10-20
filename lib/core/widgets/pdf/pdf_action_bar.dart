import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../buttons/app_button.dart';

/// Share (main action), Print and Save under a PDF preview. Buttons are
/// disabled until the PDF is ready; Share shows a spinner while busy.
class PdfActionBar extends StatelessWidget {
  const PdfActionBar({
    required this.onShare,
    required this.onPrint,
    required this.onSave,
    this.busy = false,
    super.key,
  });

  final VoidCallback? onShare;
  final VoidCallback? onPrint;
  final VoidCallback? onSave;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            Expanded(
              child: AppButton(
                label: l10n.share,
                icon: AppIcons.share,
                expand: true,
                isLoading: busy,
                onPressed: onShare,
              ),
            ),
            Flexible(
              child: AppButton(
                label: l10n.print,
                icon: AppIcons.print,
                variant: AppButtonVariant.secondary,
                onPressed: busy ? null : onPrint,
              ),
            ),
            Flexible(
              child: AppButton(
                label: l10n.saveToDevice,
                icon: AppIcons.download,
                variant: AppButtonVariant.secondary,
                onPressed: busy ? null : onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
