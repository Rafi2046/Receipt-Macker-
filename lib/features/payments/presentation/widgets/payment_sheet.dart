import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/inputs/amount_field.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/inputs/date_field.dart';
import '../../../../core/widgets/inputs/dropdown_field.dart';
import '../../domain/models/payment_field.dart';
import '../../domain/models/payment_method.dart';
import '../payment_method_label.dart';
import '../view_models/payment_form_state.dart';
import '../view_models/payment_form_view_model.dart';

/// Bottom sheet for recording or editing one payment.
class PaymentSheet extends ConsumerWidget {
  const PaymentSheet({required this.invoiceId, this.paymentId, super.key});

  final String invoiceId;
  final String? paymentId;

  static Future<bool> show(
    BuildContext context, {
    required String invoiceId,
    String? paymentId,
  }) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => PaymentSheet(invoiceId: invoiceId, paymentId: paymentId),
    );
    return saved ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = paymentFormViewModelProvider(invoiceId, paymentId);
    final async = ref.watch(provider);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: async.when(
        data: (form) => _Form(form: form, provider: provider),
        loading: () =>
            const SizedBox(height: AppSpacing.xxxl * 4, child: LoadingView()),
        error: (e, _) =>
            ErrorView.fromError(e, onRetry: () => ref.invalidate(provider)),
      ),
    );
  }
}

class _Form extends ConsumerWidget {
  const _Form({required this.form, required this.provider});

  final PaymentFormState form;
  final PaymentFormViewModelProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(provider.notifier);
    final draft = form.draft;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Text(
            form.isNew ? l10n.recordPayment : l10n.editPayment,
            style: context.textStyles.titleMedium,
          ),
          AmountField(
            label: l10n.fieldPaymentAmount,
            currencyCode: form.currencyCode,
            initialMinor: draft.amountMinor,
            errorText: l10n.validationMessage(
              form.errorFor(PaymentField.amount),
            ),
            onChanged: vm.setAmount,
          ),
          DateField(
            label: l10n.fieldPaymentDate,
            value: draft.paidOn.toLocalDateTime(),
            onChanged: vm.setDate,
          ),
          DropdownField<PaymentMethod>(
            label: l10n.fieldPaymentMethod,
            value: draft.method,
            options: [
              for (final method in PaymentMethod.values)
                (method, method.label(l10n)),
            ],
            onChanged: vm.setMethod,
          ),
          AppTextField(
            label: l10n.fieldPaymentNote,
            initialValue: draft.note,
            errorText: l10n.validationMessage(form.errorFor(PaymentField.note)),
            onChanged: vm.setNote,
          ),
          if (form.failure != null)
            Text(
              l10n.messageFor(form.failure),
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.appColors.danger,
              ),
            ),
          AppButton(
            label: l10n.save,
            expand: true,
            isLoading: form.isSaving,
            onPressed: () async {
              final saved = await vm.save();
              if (saved != null && context.mounted) {
                Navigator.of(context).pop(true);
              }
            },
          ),
        ],
      ),
    );
  }
}
