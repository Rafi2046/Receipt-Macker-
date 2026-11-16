import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../view_models/profile_form_state.dart';
import '../view_models/profile_form_view_model.dart';
import 'profile_image_preview.dart';
import 'signature_pad_sheet.dart';

/// Signature block for the business profile form.
class ProfileSignatureCard extends ConsumerWidget {
  const ProfileSignatureCard({required this.form, super.key});

  final ProfileFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(profileFormViewModelProvider.notifier);
    final path = form.draft.signaturePath;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          Text(l10n.signatureTitle, style: context.textStyles.titleSmall),
          Text(
            l10n.signatureHint,
            style: context.textStyles.bodySmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
          if (path != null)
            ProfileImagePreview(
              relativePath: path,
              semanticLabel: l10n.signatureTitle,
            ),
          if (path == null)
            AppButton(
              label: l10n.addSignature,
              icon: AppIcons.signature,
              variant: AppButtonVariant.secondary,
              onPressed: () async {
                final png = await SignaturePadSheet.show(context);
                if (png != null) await vm.setSignature(png);
              },
            )
          else
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                AppButton(
                  label: l10n.change,
                  icon: AppIcons.edit,
                  variant: AppButtonVariant.text,
                  onPressed: () async {
                    final png = await SignaturePadSheet.show(context);
                    if (png != null) await vm.setSignature(png);
                  },
                ),
                AppButton(
                  label: l10n.remove,
                  icon: AppIcons.delete,
                  variant: AppButtonVariant.text,
                  onPressed: vm.removeSignature,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
