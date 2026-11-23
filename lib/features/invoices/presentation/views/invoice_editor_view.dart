import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/editor_scaffold.dart';
import '../../domain/models/invoice.dart';
import '../view_models/invoice_editor_view_model.dart';
import '../widgets/invoice_editor_form.dart';

/// Creates an invoice, edits one ([invoiceId]), or creates a copy of
/// another ([copyOf]). A new invoice opens its detail screen once saved;
/// an edited one goes back to it.
class InvoiceEditorView extends ConsumerWidget {
  const InvoiceEditorView({this.invoiceId, this.copyOf, super.key});

  final String? invoiceId;
  final String? copyOf;

  InvoiceEditorViewModelProvider get _provider =>
      invoiceEditorViewModelProvider(invoiceId, copyOf);

  /// Saves; null (after telling the user why) when it could not.
  Future<Invoice?> _store(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final vm = ref.read(_provider.notifier);
    final saved = await vm.save();
    if (saved == null && context.mounted && vm.form?.canSave == false) {
      AppSnackbar.show(
        context,
        l10n.validationFixErrors,
        tone: AppSnackbarTone.error,
      );
    }
    return saved;
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final wantPaid =
        ref.read(_provider).value?.markPaidOnSave ?? false;
    final saved = await _store(context, ref);
    if (saved == null || !context.mounted) return;
    final payFailed = wantPaid && ref.read(_provider).value?.failure != null;
    if (!payFailed) {
      final asPaid = wantPaid && saved.paidMinor > 0;
      AppSnackbar.show(
        context,
        asPaid ? l10n.invoiceSavedPaid : l10n.invoiceSaved,
        tone: AppSnackbarTone.success,
      );
    }
    if (invoiceId != null) {
      Navigator.of(context).pop(saved);
      return;
    }
    context.pushReplacementNamed(
      RouteNames.invoiceDetail,
      pathParameters: {RouteNames.idParam: saved.id},
    );
  }

  /// Saves the invoice, then opens its PDF; back returns to the editor.
  Future<void> _preview(BuildContext context, WidgetRef ref) async {
    final saved = await _store(context, ref);
    if (saved == null || !context.mounted) return;
    await context.pushNamed(
      RouteNames.invoicePdf,
      pathParameters: {RouteNames.idParam: saved.id},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = _provider;
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
      title: invoiceId == null ? l10n.invoiceNewTitle : l10n.invoiceEditTitle,
      hasUnsavedChanges: form?.hasUnsavedChanges ?? false,
      isSaving: form?.isSaving ?? false,
      onSave: form == null ? null : () => _save(context, ref),
      secondaryLabel: l10n.editorPreview,
      onSecondary: form == null ? null : () => _preview(context, ref),
      body: async.when(
        data: (form) => InvoiceEditorForm(provider: provider, form: form),
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView.fromError(e, onRetry: () => ref.invalidate(provider)),
      ),
    );
  }
}
