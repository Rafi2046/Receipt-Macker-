import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/editor_scaffold.dart';
import '../view_models/profile_form_view_model.dart';
import 'business_profile_form.dart';

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
        data: (form) => BusinessProfileForm(form: form),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () => ref.invalidate(profileFormViewModelProvider),
        ),
      ),
    );
  }
}
