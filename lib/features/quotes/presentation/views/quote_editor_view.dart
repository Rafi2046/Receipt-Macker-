import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_bar_variant.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/confirm_dialog.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../view_models/quote_editor_view_model.dart';
import '../widgets/quote_editor_form.dart';

/// Create / edit a quote with premium card sections and Preview + Save.
class QuoteEditorView extends ConsumerWidget {
  const QuoteEditorView({this.quoteId, super.key});

  final String? quoteId;

  QuoteEditorViewModelProvider get _provider =>
      quoteEditorViewModelProvider(quoteId);

  Future<void> _confirmLeave(BuildContext context) async {
    final discard = await ConfirmDialog.show(
      context,
      title: context.l10n.discardChangesTitle,
      message: context.l10n.discardChangesMessage,
      confirmLabel: context.l10n.discard,
      destructive: true,
    );
    if (discard && context.mounted) Navigator.of(context).pop();
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final saved = await ref.read(_provider.notifier).save();
    if (saved == null || !context.mounted) return;
    AppSnackbar.show(
      context,
      context.l10n.quoteSaved,
      tone: AppSnackbarTone.success,
    );
    if (quoteId == null && context.mounted) {
      context.pushReplacementNamed(
        RouteNames.quoteEdit,
        pathParameters: {RouteNames.idParam: saved.id},
      );
    }
  }

  Future<void> _preview(BuildContext context, WidgetRef ref) async {
    final needsSave =
        quoteId == null ||
        (ref.read(_provider).value?.hasUnsavedChanges ?? false);
    String? id = quoteId;
    if (needsSave) {
      final saved = await ref.read(_provider.notifier).save();
      if (saved == null || !context.mounted) return;
      id = saved.id;
      if (quoteId == null) {
        context.pushReplacementNamed(
          RouteNames.quoteEdit,
          pathParameters: {RouteNames.idParam: id},
        );
      }
    }
    final pdfId = id;
    if (pdfId == null || !context.mounted) return;
    await context.pushNamed(
      RouteNames.quotePdf,
      pathParameters: {RouteNames.idParam: pdfId},
    );
  }

  Future<void> _convert(BuildContext context, WidgetRef ref) async {
    final invoiceId = await ref.read(_provider.notifier).convertToInvoice();
    if (invoiceId == null || !context.mounted) return;
    AppSnackbar.show(
      context,
      context.l10n.quoteConverted,
      tone: AppSnackbarTone.success,
    );
    await context.pushNamed(
      RouteNames.invoiceDetail,
      pathParameters: {RouteNames.idParam: invoiceId},
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(_provider.select((s) => s.value?.failure), (_, failure) {
      if (failure == null) return;
      ref.read(_provider.notifier).clearFailure();
      AppSnackbar.show(
        context,
        context.l10n.messageFor(failure),
        tone: AppSnackbarTone.error,
      );
    });
    final async = ref.watch(_provider);
    final form = async.value;
    final l10n = context.l10n;
    final unsaved = form?.hasUnsavedChanges ?? false;
    final busy = form?.isBusy ?? false;

    return PopScope(
      canPop: !unsaved,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave(context);
      },
      child: AppScaffold(
        title: quoteId == null ? l10n.quoteNewTitle : l10n.quoteEditTitle,
        variant: AppBarVariant.editor,
        body: async.when(
          data: (form) => Column(
            children: [
              Expanded(
                child: QuoteEditorForm(quoteId: quoteId, form: form),
              ),
              if (!form.isNew)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.pagePadding,
                    0,
                    AppSpacing.pagePadding,
                    AppSpacing.sm,
                  ),
                  child: AppButton(
                    label: form.draft.convertedInvoiceId == null
                        ? l10n.quoteConvertToInvoice
                        : l10n.quoteOpenInvoice,
                    icon: AppIcons.invoice,
                    expand: true,
                    variant: AppButtonVariant.secondary,
                    isLoading: form.isConverting,
                    onPressed: () => _convert(context, ref),
                  ),
                ),
            ],
          ),
          loading: () => const LoadingView(),
          error: (e, _) =>
              ErrorView.fromError(e, onRetry: () => ref.invalidate(_provider)),
        ),
        bottomBarAboveKeyboard: true,
        bottomBar: form == null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: l10n.quotePreview,
                          icon: AppIcons.pdf,
                          variant: AppButtonVariant.secondary,
                          onPressed: busy ? null : () => _preview(context, ref),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: AppButton(
                          label: l10n.save,
                          expand: true,
                          isLoading: form.isSaving,
                          onPressed: busy ? null : () => _save(context, ref),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
