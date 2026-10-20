import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_icon_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/confirm_dialog.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../domain/models/invoice_stage.dart';
import '../view_models/invoice_detail_view_model.dart';
import '../widgets/invoice_detail_body.dart';

enum _Action { duplicate, markSent, markDraft, delete }

/// One invoice, read-only, with Edit, Duplicate, Mark as sent and Delete.
/// PDF preview and share arrive in M5, payments in M6.
class InvoiceDetailView extends ConsumerWidget {
  const InvoiceDetailView({required this.invoiceId, super.key});

  final String invoiceId;

  Future<void> _run(BuildContext context, WidgetRef ref, _Action action) async {
    final l10n = context.l10n;
    final vm = ref.read(invoiceDetailViewModelProvider(invoiceId).notifier);
    switch (action) {
      case _Action.duplicate:
        await context.pushNamed(
          RouteNames.invoiceNew,
          queryParameters: {RouteNames.copyOfParam: invoiceId},
        );
      case _Action.markSent || _Action.markDraft:
        final sent = action == _Action.markSent;
        final result = await vm.setStage(
          sent ? InvoiceStage.sent : InvoiceStage.draft,
        );
        if (!context.mounted) return;
        _report(
          context,
          result,
          sent ? l10n.invoiceMarkedSent : l10n.invoiceMarkedDraft,
        );
      case _Action.delete:
        final number =
            ref
                .read(invoiceDetailViewModelProvider(invoiceId))
                .value
                ?.invoice
                .number ??
            '';
        final confirmed = await ConfirmDialog.show(
          context,
          title: l10n.invoiceDeleteTitle,
          message: l10n.invoiceDeleteMessage(number),
          confirmLabel: l10n.delete,
          destructive: true,
        );
        if (!confirmed || !context.mounted) return;
        final result = await vm.delete();
        if (!context.mounted) return;
        _report(context, result, l10n.invoiceDeleted);
        if (result.isOk) Navigator.of(context).pop();
    }
  }

  void _openPdf(BuildContext context) => context.pushNamed(
    RouteNames.invoicePdf,
    pathParameters: {RouteNames.idParam: invoiceId},
  );

  static void _report(BuildContext context, Result<void> result, String ok) {
    switch (result) {
      case Ok():
        AppSnackbar.show(context, ok, tone: AppSnackbarTone.success);
      case Err(:final failure):
        AppSnackbar.show(
          context,
          context.l10n.messageFor(failure),
          tone: AppSnackbarTone.error,
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final async = ref.watch(invoiceDetailViewModelProvider(invoiceId));
    final state = async.value;
    final isDraft = state?.invoice.stage == InvoiceStage.draft;
    return AppScaffold(
      title: l10n.invoicesTitle,
      actions: [
        if (state != null) ...[
          AppIconButton(
            icon: AppIcons.share,
            semanticLabel: l10n.previewAndShare,
            onPressed: () => _openPdf(context),
          ),
          AppIconButton(
            icon: AppIcons.edit,
            semanticLabel: l10n.edit,
            onPressed: () => context.pushNamed(
              RouteNames.invoiceEdit,
              pathParameters: {RouteNames.idParam: invoiceId},
            ),
          ),
          PopupMenuButton<_Action>(
            tooltip: l10n.moreActions,
            onSelected: (a) => _run(context, ref, a),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: _Action.duplicate,
                child: Text(l10n.invoiceDuplicate),
              ),
              PopupMenuItem(
                value: isDraft ? _Action.markSent : _Action.markDraft,
                child: Text(
                  isDraft ? l10n.invoiceMarkSent : l10n.invoiceMarkDraft,
                ),
              ),
              PopupMenuItem(value: _Action.delete, child: Text(l10n.delete)),
            ],
          ),
        ],
      ],
      body: async.when(
        data: (s) =>
            InvoiceDetailBody(state: s, onPreview: () => _openPdf(context)),
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView.fromError(
          e,
          onRetry: () =>
              ref.invalidate(invoiceDetailViewModelProvider(invoiceId)),
        ),
      ),
    );
  }
}
