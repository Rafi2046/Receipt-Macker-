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

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final vm = ref.read(_provider.notifier);
    final saved = await vm.save();
    if (!context.mounted) return;
    if (saved == null) {
      if (vm.form?.canSave == false) {
        AppSnackbar.show(
          context,
          l10n.validationFixErrors,
          tone: AppSnackbarTone.error,
        );
      }
      return;
    }
    AppSnackbar.show(context, l10n.invoiceSaved, tone: AppSnackbarTone.success);
    if (invoiceId != null) {
      Navigator.of(context).pop(saved);
      return;
    }
    context.pushReplacementNamed(
      RouteNames.invoiceDetail,
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
      body: async.when(
        data: (form) => InvoiceEditorForm(provider: provider, form: form),
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView.fromError(e, onRetry: () => ref.invalidate(provider)),
      ),
    );
  }
}
