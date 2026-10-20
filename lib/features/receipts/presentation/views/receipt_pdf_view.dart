import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/utils/extensions/failure_message_extension.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/feedback/error_view.dart';
import '../../../../core/widgets/feedback/loading_view.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../../../../core/widgets/pdf/pdf_action_bar.dart';
import '../../../../core/widgets/pdf/pdf_options_bar.dart';
import '../../../../core/widgets/pdf/pdf_page_list.dart';
import '../../../business_profile/business_profile.dart';
import '../../../payments/providers.dart';
import '../view_models/receipt_pdf_state.dart';
import '../view_models/receipt_pdf_view_model.dart';

/// Receipt PDF: design, language, pages, then share, print or save.
class ReceiptPdfView extends ConsumerWidget {
  const ReceiptPdfView({required this.paymentId, super.key});

  final String paymentId;

  ReceiptPdfViewModelProvider get _provider =>
      receiptPdfViewModelProvider(paymentId);

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final payment = await ref.read(paymentRepositoryProvider).find(paymentId);
    final business = ref.read(currentBusinessProfileProvider).value?.name;
    final shared = await ref
        .read(_provider.notifier)
        .share(
          subject: l10n.shareReceiptSubject(
            payment.valueOrNull?.receiptNumber ?? '',
            business ?? '',
          ),
        );
    if (!shared || !context.mounted) return;
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final saved = await ref.read(_provider.notifier).save();
    if (saved && context.mounted) {
      AppSnackbar.show(
        context,
        context.l10n.pdfSaved,
        tone: AppSnackbarTone.success,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(_provider.select((s) => s.actionFailure), (_, failure) {
      if (failure == null) return;
      AppSnackbar.show(
        context,
        context.l10n.messageFor(failure),
        tone: AppSnackbarTone.error,
      );
      ref.read(_provider.notifier).clearActionFailure();
    });
    final state = ref.watch(_provider);
    final vm = ref.read(_provider.notifier);
    final ready = state.isReady;
    return AppScaffold(
      title: context.l10n.pdfPreviewTitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PdfOptionsBar(
            template: state.template,
            languageCode: state.languageCode,
            enabled: !state.isRendering,
            onTemplate: vm.setTemplate,
            onLanguage: vm.setLanguage,
          ),
          Expanded(
            child: _Pages(state: state, provider: _provider),
          ),
        ],
      ),
      bottomBar: PdfActionBar(
        busy: state.isBusy,
        onShare: ready ? () => _share(context, ref) : null,
        onPrint: ready ? vm.print : null,
        onSave: ready ? () => _save(context, ref) : null,
      ),
    );
  }
}

class _Pages extends ConsumerWidget {
  const _Pages({required this.state, required this.provider});

  final ReceiptPdfState state;
  final ReceiptPdfViewModelProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final failure = state.renderFailure;
    if (state.isRendering) return LoadingView(message: context.l10n.pdfMaking);
    if (failure != null) return _Failed(failure: failure, provider: provider);
    return PdfPageList(pages: state.pages);
  }
}

class _Failed extends ConsumerWidget {
  const _Failed({required this.failure, required this.provider});

  final Failure failure;
  final ReceiptPdfViewModelProvider provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(provider.notifier);
    return Column(
      children: [
        Expanded(child: ErrorView.fromError(failure, onRetry: vm.render)),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: AppButton(
            label: context.l10n.openPrintDialog,
            icon: AppIcons.print,
            variant: AppButtonVariant.secondary,
            onPressed: vm.printWithSystemDialog,
          ),
        ),
      ],
    );
  }
}
