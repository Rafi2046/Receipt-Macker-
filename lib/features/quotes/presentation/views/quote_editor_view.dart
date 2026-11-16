import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/editor_scaffold.dart';
import '../../../invoices/presentation/widgets/client_picker_sheet.dart';
import '../../../invoices/presentation/widgets/item_pick.dart';
import '../../../invoices/presentation/widgets/item_picker_sheet.dart';
import '../../domain/models/quote_status.dart';
import '../view_models/quote_editor_view_model.dart';

/// Create / edit a quote; convert to invoice when ready.
class QuoteEditorView extends ConsumerWidget {
  const QuoteEditorView({this.quoteId, super.key});

  final String? quoteId;

  Future<void> _pickClient(BuildContext context, WidgetRef ref) async {
    final client = await ClientPickerSheet.show(context);
    if (client == null || !context.mounted) return;
    ref.read(quoteEditorViewModelProvider(quoteId).notifier).setClient(client);
  }

  Future<void> _pickItem(BuildContext context, WidgetRef ref) async {
    final pick = await ItemPickerSheet.show(context);
    if (pick is! SavedItemPick || !context.mounted) return;
    ref.read(quoteEditorViewModelProvider(quoteId).notifier).addItem(pick.item);
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final saved = await ref
        .read(quoteEditorViewModelProvider(quoteId).notifier)
        .save();
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

  Future<void> _convert(BuildContext context, WidgetRef ref) async {
    final invoiceId = await ref
        .read(quoteEditorViewModelProvider(quoteId).notifier)
        .convertToInvoice();
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

  Future<void> _previewPdf(BuildContext context, WidgetRef ref) async {
    final needsSave = quoteId == null ||
        (ref.read(quoteEditorViewModelProvider(quoteId)).value?.hasUnsavedChanges ??
            false);
    String? id = quoteId;
    if (needsSave) {
      final saved = await ref
          .read(quoteEditorViewModelProvider(quoteId).notifier)
          .save();
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = quoteEditorViewModelProvider(quoteId);
    ref.listen(provider.select((s) => s.value?.failure), (_, failure) {
      if (failure == null) return;
      ref.read(provider.notifier).clearFailure();
      AppSnackbar.show(
        context,
        context.l10n.messageFor(failure),
        tone: AppSnackbarTone.error,
      );
    });
    final async = ref.watch(provider);
    final form = async.value;
    final l10n = context.l10n;
    return EditorScaffold(
      title: quoteId == null ? l10n.quoteNewTitle : l10n.quoteEditTitle,
      hasUnsavedChanges: form?.hasUnsavedChanges ?? false,
      isSaving: form?.isBusy ?? false,
      onSave: form == null ? null : () => _save(context, ref),
      body: async.when(
        data: (form) {
          final format = AppFormatters(
            Localizations.localeOf(context).languageCode,
          );
          final total = ref.read(provider.notifier).totalMinor();
          final colors = context.appColors;
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.pagePadding),
            children: [
              AppCard(
                onTap: () => _pickClient(context, ref),
                child: Row(
                  children: [
                    Icon(AppIcons.client, color: colors.primary),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        form.draft.billTo?.name ?? l10n.quoteAddClient,
                        style: context.textStyles.titleSmall,
                      ),
                    ),
                    const Icon(AppIcons.chevronRight),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      form.draft.number,
                      style: context.textStyles.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        for (final status in QuoteStatus.values)
                          ChoiceChip(
                            label: Text(switch (status) {
                              QuoteStatus.pending => l10n.quoteStatusPending,
                              QuoteStatus.approved => l10n.quoteStatusApproved,
                              QuoteStatus.rejected => l10n.quoteStatusRejected,
                            }),
                            selected: form.draft.status == status,
                            onSelected: (_) =>
                                ref.read(provider.notifier).setStatus(status),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.quoteItems,
                            style: context.textStyles.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _pickItem(context, ref),
                          icon: const Icon(AppIcons.add),
                          label: Text(l10n.quoteAddItem),
                        ),
                      ],
                    ),
                    if (form.draft.lines.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.md,
                        ),
                        child: Text(
                          l10n.quoteNoItems,
                          style: context.textStyles.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                      )
                    else
                      for (final line in form.draft.lines)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(line.name),
                          subtitle: Text(
                            format.currency(
                              line.unitPriceMinor,
                              form.draft.currencyCode,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(AppIcons.delete),
                            onPressed: () =>
                                ref.read(provider.notifier).removeLine(line.id),
                          ),
                        ),
                    const Divider(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        format.currency(total, form.draft.currencyCode),
                        style: context.textStyles.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: l10n.quotePreviewPdf,
                icon: AppIcons.pdf,
                variant: AppButtonVariant.secondary,
                onPressed: () => _previewPdf(context, ref),
              ),
              if (!form.isNew) ...[
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: form.draft.convertedInvoiceId == null
                      ? l10n.quoteConvertToInvoice
                      : l10n.quoteOpenInvoice,
                  icon: AppIcons.invoice,
                  isLoading: form.isConverting,
                  onPressed: () => _convert(context, ref),
                ),
              ],
            ],
          );
        },
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView.fromError(e, onRetry: () => ref.invalidate(provider)),
      ),
    );
  }
}
