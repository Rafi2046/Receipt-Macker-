import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_document_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';

/// Bottom sheet with a drawing pad. Resolves to PNG bytes (transparent
/// background, dark ink) or null when cancelled.
class SignaturePadSheet extends StatefulWidget {
  const SignaturePadSheet({super.key});

  static Future<Uint8List?> show(BuildContext context) =>
      showModalBottomSheet<Uint8List>(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (_) => const SignaturePadSheet(),
      );

  @override
  State<SignaturePadSheet> createState() => _SignaturePadSheetState();
}

class _SignaturePadSheetState extends State<SignaturePadSheet> {
  final _controller = SignatureController(
    penStrokeWidth: AppSizes.signatureStroke,
    penColor: AppDocumentColors.ink,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_controller.isEmpty) {
      AppSnackbar.show(
        context,
        context.l10n.signatureEmpty,
        tone: AppSnackbarTone.error,
      );
      return;
    }
    final bytes = await _controller.toPngBytes();
    if (mounted) Navigator.of(context).pop(bytes);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Text(l10n.signaturePadTitle, style: context.textStyles.titleMedium),
          ClipRRect(
            borderRadius: AppRadius.card,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: context.appColors.border),
                borderRadius: AppRadius.card,
              ),
              child: Signature(
                controller: _controller,
                height: AppSizes.signaturePadHeight,
                backgroundColor: AppDocumentColors.paper,
              ),
            ),
          ),
          Row(
            children: [
              AppButton(
                label: l10n.clear,
                variant: AppButtonVariant.text,
                onPressed: _controller.clear,
              ),
              const Spacer(),
              AppButton(
                label: l10n.cancel,
                variant: AppButtonVariant.text,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(label: l10n.save, onPressed: _save),
            ],
          ),
        ],
      ),
    );
  }
}
