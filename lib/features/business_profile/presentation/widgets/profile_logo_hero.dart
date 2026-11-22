import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../view_models/profile_form_state.dart';
import '../view_models/profile_form_view_model.dart';
import 'dashed_border_painter.dart';
import 'profile_image_preview.dart';

/// The logo, large and centered at the top of the profile: a dashed
/// "Logo" slot to add one, or the logo with Change / Remove.
class ProfileLogoHero extends ConsumerWidget {
  const ProfileLogoHero({required this.form, super.key});

  final ProfileFormState form;

  /// Side of the logo square.
  static const double _size = AppSizes.logoMd * 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final vm = ref.read(profileFormViewModelProvider.notifier);
    final path = form.draft.logoPath;
    final busy = form.isPickingImage;
    return Column(
      spacing: AppSpacing.xs,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.lg)),
          ),
          child: Material(
            color: colors.primary.withValues(alpha: 0.06),
            borderRadius: AppRadius.card,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: busy ? null : vm.pickLogo,
              child: SizedBox.square(
                dimension: _size,
                child: path == null
                    ? CustomPaint(
                        painter: DashedBorderPainter(color: colors.primary),
                        child: _EmptySlot(busy: busy, label: l10n.logoTitle),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: ProfileImagePreview(
                          relativePath: path,
                          semanticLabel: l10n.logoTitle,
                          height: _size,
                        ),
                      ),
              ),
            ),
          ),
        ),
        if (path != null)
          Wrap(
            alignment: WrapAlignment.center,
            spacing: AppSpacing.sm,
            children: [
              AppButton(
                label: l10n.change,
                variant: AppButtonVariant.text,
                onPressed: busy ? null : vm.pickLogo,
              ),
              AppButton(
                label: l10n.remove,
                variant: AppButtonVariant.text,
                onPressed: vm.removeLogo,
              ),
            ],
          ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot({required this.busy, required this.label});

  final bool busy;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (busy) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppSpacing.sm,
      children: [
        Icon(AppIcons.image, color: colors.primary, size: AppSizes.iconLg),
        Text(
          label,
          style: context.textStyles.titleSmall?.copyWith(
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}
