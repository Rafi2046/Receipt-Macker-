import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/editor_scaffold.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../domain/models/profile_field.dart';
import '../view_models/profile_form_state.dart';
import '../view_models/profile_form_view_model.dart';
import '../widgets/profile_details_fields.dart';
import '../widgets/profile_logo_picker.dart';
import '../widgets/profile_signature_card.dart';

/// Edit every business profile field after onboarding.
/// Opened from the drawer / More → Business profile.
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
    return EditorScaffold(
      title: context.l10n.businessProfileTitle,
      hasUnsavedChanges: form?.hasUnsavedChanges ?? false,
      isSaving: form?.isSaving ?? false,
      onSave: form == null ? null : () => _save(context, ref),
      body: async.when(
        data: (form) => _ProfileForm(form: form),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(profileFormViewModelProvider),
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
        ProfileLogoPicker(form: form),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: ProfileDetailsFields(
            form: form,
            showIcons: false,
            optionalHint: true,
            fields: const [
              ProfileField.name,
              ProfileField.phone,
              ProfileField.email,
              ProfileField.website,
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: ProfileDetailsFields(
            form: form,
            showIcons: false,
            optionalHint: true,
            fields: const [ProfileField.address],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: ProfileDetailsFields(
            form: form,
            showIcons: false,
            optionalHint: true,
            fields: const [ProfileField.taxId],
          ),
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        SectionHeader(title: l10n.sectionInvoiceDefaults),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          child: ProfileDetailsFields(
            form: form,
            showIcons: false,
            optionalHint: true,
            fields: const [
              ProfileField.paymentInstructions,
              ProfileField.defaultNotes,
              ProfileField.defaultTerms,
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ProfileSignatureCard(form: form),
      ],
    );
  }
}
