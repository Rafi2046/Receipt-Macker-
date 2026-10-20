import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/confirm_dialog.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../view_models/profile_form_state.dart';
import '../view_models/profile_form_view_model.dart';
import '../widgets/profile_details_fields.dart';
import '../widgets/profile_images_section.dart';

/// Edit every business profile field after onboarding.
class BusinessProfileView extends ConsumerWidget {
  const BusinessProfileView({super.key});

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final saved = await ref.read(profileFormViewModelProvider.notifier).save();
    if (saved && context.mounted) {
      AppSnackbar.show(
        context,
        context.l10n.profileSaved,
        tone: AppSnackbarTone.success,
      );
    }
  }

  Future<void> _confirmLeave(BuildContext context) async {
    final l10n = context.l10n;
    final discard = await ConfirmDialog.show(
      context,
      title: l10n.discardChangesTitle,
      message: l10n.discardChangesMessage,
      confirmLabel: l10n.discard,
      destructive: true,
    );
    if (discard && context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(profileFormViewModelProvider.select((s) => s.value?.failure), (
      _,
      failure,
    ) {
      if (failure == null) return;
      AppSnackbar.show(
        context,
        context.l10n.messageFor(failure),
        tone: AppSnackbarTone.error,
      );
      ref.read(profileFormViewModelProvider.notifier).clearFailure();
    });
    final async = ref.watch(profileFormViewModelProvider);
    final form = async.value;
    return PopScope(
      canPop: !(form?.hasUnsavedChanges ?? false),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave(context);
      },
      child: AppScaffold(
        title: context.l10n.businessProfileTitle,
        body: async.when(
          data: (form) => _ProfileForm(form: form),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView.fromError(
            e,
            onRetry: () => ref.invalidate(profileFormViewModelProvider),
          ),
        ),
        bottomBar: form == null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: AppButton(
                    label: context.l10n.save,
                    expand: true,
                    isLoading: form.isSaving,
                    onPressed: () => _save(context, ref),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({required this.form});

  final ProfileFormState form;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        SectionHeader(title: l10n.sectionBranding),
        const SizedBox(height: AppSpacing.sm),
        ProfileImagesSection(form: form),
        const SizedBox(height: AppSpacing.sectionGap),
        SectionHeader(title: l10n.sectionBusinessDetails),
        const SizedBox(height: AppSpacing.sm),
        ProfileDetailsFields(form: form, extended: true),
      ],
    );
  }
}
