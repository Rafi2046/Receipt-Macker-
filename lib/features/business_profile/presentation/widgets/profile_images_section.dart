import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../view_models/profile_form_state.dart';
import '../view_models/profile_form_view_model.dart';
import 'profile_image_tile.dart';
import 'signature_pad_sheet.dart';

/// Logo (from the gallery) and signature (drawn) for the business profile.
class ProfileImagesSection extends ConsumerWidget {
  const ProfileImagesSection({required this.form, super.key});

  final ProfileFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(profileFormViewModelProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        ProfileImageTile(
          title: l10n.logoTitle,
          hint: l10n.logoHint,
          addLabel: l10n.addLogo,
          addIcon: AppIcons.image,
          relativePath: form.draft.logoPath,
          isBusy: form.isPickingImage,
          onAdd: vm.pickLogo,
          onRemove: vm.removeLogo,
        ),
        ProfileImageTile(
          title: l10n.signatureTitle,
          hint: l10n.signatureHint,
          addLabel: l10n.addSignature,
          addIcon: AppIcons.signature,
          relativePath: form.draft.signaturePath,
          onAdd: () async {
            final png = await SignaturePadSheet.show(context);
            if (png != null) await vm.setSignature(png);
          },
          onRemove: vm.removeSignature,
        ),
      ],
    );
  }
}
