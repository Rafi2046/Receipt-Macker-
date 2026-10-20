import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/confirm_dialog.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/editor_scaffold.dart';
import '../view_models/client_editor_view_model.dart';
import '../widgets/client_form_fields.dart';

/// Adds a client ([clientId] null) or edits one. Pops with the saved
/// client, so other screens (the invoice editor) can pick it right away.
class ClientEditorView extends ConsumerWidget {
  const ClientEditorView({this.clientId, super.key});

  final String? clientId;

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final provider = clientEditorViewModelProvider(clientId);
    final saved = await ref.read(provider.notifier).save();
    if (saved == null || !context.mounted) return;
    AppSnackbar.show(
      context,
      context.l10n.clientSaved,
      tone: AppSnackbarTone.success,
    );
    Navigator.of(context).pop(saved);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String name) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.clientDeleteTitle,
      message: l10n.clientDeleteMessage(name),
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final provider = clientEditorViewModelProvider(clientId);
    final deleted = await ref.read(provider.notifier).delete();
    if (!deleted || !context.mounted) return;
    AppSnackbar.show(context, l10n.clientDeleted);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = clientEditorViewModelProvider(clientId);
    ref.listen(provider.select((s) => s.value?.failure), (_, failure) {
      if (failure == null) return;
      AppSnackbar.show(
        context,
        context.l10n.messageFor(failure),
        tone: AppSnackbarTone.error,
      );
      ref.read(provider.notifier).clearFailure();
    });
    final async = ref.watch(provider);
    final form = async.value;
    final l10n = context.l10n;
    return EditorScaffold(
      title: clientId == null ? l10n.clientNewTitle : l10n.clientEditTitle,
      hasUnsavedChanges: form?.hasUnsavedChanges ?? false,
      isSaving: form?.isBusy ?? false,
      onSave: form == null ? null : () => _save(context, ref),
      onDelete: form == null || form.isNew
          ? null
          : () => _delete(context, ref, form.initial.name),
      body: async.when(
        data: (form) => ClientFormFields(
          form: form,
          onChanged: ref.read(provider.notifier).updateField,
        ),
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView.fromError(e, onRetry: () => ref.invalidate(provider)),
      ),
    );
  }
}
