import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/buttons/app_icon_button.dart';
import '../../../../core/widgets/display/amount_text.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/confirm_dialog.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../../invoices/presentation/view_models/invoice_detail_state.dart';
import '../../domain/models/payment.dart';
import '../../providers.dart';
import '../payment_method_label.dart';
import '../view_models/invoice_payments_provider.dart';
import 'payment_sheet.dart';

/// Payments on an invoice, with record, edit and delete.
class InvoicePaymentsSection extends ConsumerWidget {
  const InvoicePaymentsSection({required this.state, super.key});

  final InvoiceDetailState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final invoiceId = state.invoice.id;
    final payments = ref.watch(invoicePaymentsProvider(invoiceId));
    final canRecord = state.totals.balance > 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.sectionGap,
            bottom: AppSpacing.sm,
          ),
          child: SectionHeader(title: l10n.sectionPayments),
        ),
        payments.when(
          data: (list) => _List(
            payments: list,
            currencyCode: state.invoice.currencyCode,
            onEdit: (id) => _open(context, ref, paymentId: id),
            onDelete: (payment) => _delete(context, ref, payment),
          ),
          loading: () => const LoadingView(),
          error: (e, _) => ErrorView.fromError(
            e,
            onRetry: () => ref.invalidate(invoicePaymentsProvider(invoiceId)),
          ),
        ),
        if (canRecord) ...[
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: l10n.recordPayment,
            icon: AppIcons.payment,
            expand: true,
            onPressed: () => _open(context, ref),
          ),
        ],
      ],
    );
  }

  Future<void> _open(
    BuildContext context,
    WidgetRef ref, {
    String? paymentId,
  }) async {
    final saved = await PaymentSheet.show(
      context,
      invoiceId: state.invoice.id,
      paymentId: paymentId,
    );
    if (saved && context.mounted) {
      AppSnackbar.show(
        context,
        context.l10n.paymentSaved,
        tone: AppSnackbarTone.success,
      );
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Payment payment,
  ) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmDialog.show(
      context,
      title: l10n.paymentDeleteTitle,
      message: l10n.paymentDeleteMessage,
      confirmLabel: l10n.delete,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final result = await ref.read(paymentRepositoryProvider).delete(payment.id);
    if (!context.mounted) return;
    switch (result) {
      case Ok():
        AppSnackbar.show(
          context,
          l10n.paymentDeleted,
          tone: AppSnackbarTone.success,
        );
      case Err(:final failure):
        AppSnackbar.show(
          context,
          l10n.messageFor(failure),
          tone: AppSnackbarTone.error,
        );
    }
  }
}

class _List extends StatelessWidget {
  const _List({
    required this.payments,
    required this.currencyCode,
    required this.onEdit,
    required this.onDelete,
  });

  final List<Payment> payments;
  final String currencyCode;
  final ValueChanged<String> onEdit;
  final ValueChanged<Payment> onDelete;

  @override
  Widget build(BuildContext context) {
    if (payments.isEmpty) {
      return Text(
        context.l10n.paymentsEmpty,
        style: context.textStyles.bodyMedium?.copyWith(
          color: context.appColors.textSecondary,
        ),
      );
    }
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        children: [
          for (final payment in payments)
            _PaymentTile(
              payment: payment,
              currencyCode: currencyCode,
              onEdit: () => onEdit(payment.id),
              onDelete: () => onDelete(payment),
            ),
        ],
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.payment,
    required this.currencyCode,
    required this.onEdit,
    required this.onDelete,
  });

  final Payment payment;
  final String currencyCode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final secondary = context.textStyles.bodySmall?.copyWith(
      color: context.appColors.textSecondary,
    );
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AmountText(
                minor: payment.amountMinor,
                currencyCode: currencyCode,
              ),
              Text(
                '${format.calendarDate(payment.paidOn)} · ${payment.method.label(l10n)}',
                style: secondary,
              ),
            ],
          ),
        ),
        AppIconButton(
          icon: AppIcons.edit,
          semanticLabel: l10n.edit,
          onPressed: onEdit,
        ),
        AppIconButton(
          icon: AppIcons.delete,
          semanticLabel: l10n.delete,
          onPressed: onDelete,
        ),
      ],
    );
  }
}
