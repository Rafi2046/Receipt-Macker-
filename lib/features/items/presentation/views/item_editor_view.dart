import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/confirm_dialog.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/editor_scaffold.dart';
import '../view_models/item_editor_view_model.dart';
import '../widgets/item_form_fields.dart';

/// Adds an item ([itemId] null) or edits one. Pops with the saved item,
/// so other screens (the invoice editor) can pick it right away.
class ItemEditorView extends ConsumerWidget {
  const ItemEditorView({this.itemId, super.key});

  final String? itemId;

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final provider = itemEditorViewModelProvider(itemId);
    final saved = await ref.read(provider.notifier).save();
    if (saved == null || !context.mounted) return;
    AppSnackbar.show(
      context,
      context.l10n.itemSaved,
      tone: AppSnackbarTone.success,
    );
    Navigator.of(context).pop(saved);
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String name) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.itemDeleteTitle,
      message: l10n.itemDeleteMessage(name),
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final provider = itemEditorViewModelProvider(itemId);
    final deleted = await ref.read(provider.notifier).delete();
    if (!deleted || !context.mounted) return;
    AppSnackbar.show(context, l10n.itemDeleted);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = itemEditorViewModelProvider(itemId);
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
      title: itemId == null ? l10n.itemNewTitle : l10n.itemEditTitle,
      hasUnsavedChanges: form?.hasUnsavedChanges ?? false,
      isSaving: form?.isBusy ?? false,
      onSave: form == null ? null : () => _save(context, ref),
      onDelete: form == null || form.isNew
          ? null
          : () => _delete(context, ref, form.initial.name),
      body: async.when(
        data: (form) =>
            ItemFormFields(form: form, vm: ref.read(provider.notifier)),
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView.fromError(e, onRetry: () => ref.invalidate(provider)),
      ),
    );
  }
}
