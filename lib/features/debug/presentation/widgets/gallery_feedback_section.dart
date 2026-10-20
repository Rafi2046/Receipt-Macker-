import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/confirm_dialog.dart';
import '../../../../core/widgets/feedback/empty_state.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_card.dart';

class GalleryFeedbackSection extends StatelessWidget {
  const GalleryFeedbackSection({super.key});

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = context.l10n;
    final deleted = await ConfirmDialog.show(
      context,
      title: l10n.galleryDialogTitle,
      message: l10n.galleryDialogMessage,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!context.mounted) return;
    AppSnackbar.show(
      context,
      deleted ? l10n.galleryDeleted : l10n.galleryKept,
      tone: deleted ? AppSnackbarTone.success : AppSnackbarTone.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        AppCard(
          child: EmptyState(
            icon: AppIcons.invoice,
            title: l10n.galleryEmptyTitle,
            message: l10n.galleryEmptyMessage,
            actionLabel: l10n.galleryEmptyAction,
            onAction: () {},
          ),
        ),
        AppCard(
          child: ErrorView.fromError(const DatabaseFailure(), onRetry: () {}),
        ),
        const AppCard(child: LoadingView()),
        AppButton(
          label: l10n.galleryShowSnackbar,
          variant: AppButtonVariant.secondary,
          onPressed: () => AppSnackbar.show(
            context,
            l10n.gallerySnackbarMessage,
            tone: AppSnackbarTone.success,
            actionLabel: l10n.galleryUndo,
          ),
        ),
        AppButton(
          label: l10n.galleryShowDialog,
          variant: AppButtonVariant.secondary,
          onPressed: () => _confirmDelete(context),
        ),
      ],
    );
  }
}
