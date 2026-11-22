import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/currency_picker_sheet.dart';
import '../../../../core/widgets/pdf/template_picker_card.dart';
import '../../../business_profile/business_profile.dart';
import '../view_models/invoice_editor_state.dart';
import '../view_models/invoice_editor_view_model.dart';
import 'client_picker_sheet.dart';
import 'invoice_adjustment_card.dart';
import 'invoice_adjustments_section.dart';
import 'invoice_editor_sheet.dart';
import 'invoice_header_section.dart';
import 'invoice_items_card.dart';
import 'invoice_notes_section.dart';
import 'invoice_number_card.dart';
import 'invoice_options_card.dart';
import 'invoice_parties_card.dart';
import 'item_pick.dart';
import 'item_picker_sheet.dart';
import 'line_item_sheet.dart';

/// The invoice editor's page, one card per step: number and dates, the
/// template, who it is from and for, items, adjustments with the total,
/// then currency, payment, signature and terms. Each card opens a sheet.
class InvoiceEditorForm extends ConsumerWidget {
  const InvoiceEditorForm({
    required this.provider,
    required this.form,
    super.key,
  });

  final InvoiceEditorViewModelProvider provider;
  final InvoiceEditorState form;

  Future<void> _chooseClient(BuildContext context, WidgetRef ref) async {
    final client = await ClientPickerSheet.show(context);
    if (client != null) ref.read(provider.notifier).setClient(client);
  }

  Future<void> _addLine(BuildContext context, WidgetRef ref) async {
    final pick = await ItemPickerSheet.show(context);
    if (pick == null || !context.mounted) return;
    final vm = ref.read(provider.notifier);
    switch (pick) {
      case SavedItemPick(:final item):
        final added = vm.addItem(item);
        if (added.needsPrice) await _editLine(context, ref, added.lineId);
      case OneOffItemPick():
        await _editLine(context, ref, vm.addBlankLine());
    }
  }

  Future<void> _editLine(BuildContext context, WidgetRef ref, String id) =>
      LineItemSheet.show(context, ref, provider: provider, lineId: id);

  Future<void> _sheet(
    BuildContext context,
    String title,
    InvoiceSheetBuilder builder,
  ) => InvoiceEditorSheet.show(
    context,
    provider: provider,
    title: title,
    builder: builder,
  );

  Future<void> _chooseCurrency(BuildContext context, WidgetRef ref) async {
    final current = form.draft.currencyCode;
    final code = await showCurrencyPicker(
      context: context,
      selectedCode: current,
      codes: {...AppCurrencies.common, current}.toList(),
    );
    if (code != null) ref.read(provider.notifier).setCurrency(code);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(provider.notifier);
    final draft = form.draft;
    final profile = ref.watch(currentBusinessProfileProvider).value;
    void openProfile() => context.pushNamed(RouteNames.businessProfile);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.sm,
        AppSpacing.pagePadding,
        AppSpacing.xxl,
      ),
      children: [
        InvoiceNumberCard(
          form: form,
          onTap: () => _sheet(
            context,
            l10n.sectionInvoiceDetails,
            (form, vm) =>
                InvoiceHeaderSection(form: form, vm: vm, showCurrency: false),
          ),
        ),
        const _Gap(),
        const TemplatePickerCard(),
        const _Gap(),
        InvoicePartiesCard(
          businessName: profile?.name ?? '',
          billTo: draft.billTo,
          onBusiness: openProfile,
          onChooseClient: () => _chooseClient(context, ref),
          onRemoveClient: vm.clearClient,
        ),
        const _Gap(),
        InvoiceItemsCard(
          form: form,
          onAdd: () => _addLine(context, ref),
          onEditLine: (id) => _editLine(context, ref, id),
        ),
        const _Gap(),
        InvoiceAdjustmentCard(
          totals: form.totals,
          taxRateBasisPoints: draft.taxRateBasisPoints,
          taxInclusive: draft.taxInclusive,
          onTap: () => _sheet(
            context,
            l10n.editorAdjustment,
            (form, vm) => InvoiceAdjustmentsSection(form: form, vm: vm),
          ),
        ),
        const _Gap(),
        InvoiceOptionsCard(
          draft: draft,
          hasSignature: profile?.signaturePath != null,
          onCurrency: () => _chooseCurrency(context, ref),
          onPayment: () => _sheet(
            context,
            l10n.editorPaymentMethod,
            (form, vm) =>
                InvoiceNotesSection(form: form, vm: vm, showNotes: false),
          ),
          onSignature: openProfile,
          onNotes: () => _sheet(
            context,
            l10n.editorTermsNotes,
            (form, vm) =>
                InvoiceNotesSection(form: form, vm: vm, showPayment: false),
          ),
        ),
      ],
    );
  }
}

/// Space between two cards.
class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: AppSpacing.md);
}
