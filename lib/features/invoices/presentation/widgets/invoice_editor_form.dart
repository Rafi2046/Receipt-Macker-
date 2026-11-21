import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/inputs/soft_input_theme.dart';
import '../../../../core/widgets/layout/form_section.dart';
import '../view_models/invoice_editor_state.dart';
import '../view_models/invoice_editor_view_model.dart';
import 'bill_to_card.dart';
import 'client_picker_sheet.dart';
import 'invoice_adjustments_section.dart';
import 'invoice_editor_hero.dart';
import 'invoice_header_section.dart';
import 'invoice_lines_section.dart';
import 'invoice_notes_section.dart';
import 'item_pick.dart';
import 'item_picker_sheet.dart';
import 'line_item_sheet.dart';
import 'totals_summary.dart';

/// The invoice editor's page: details, bill to, items, adjustments,
/// totals and notes.
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final vm = ref.read(provider.notifier);
    final draft = form.draft;
    return SoftInputTheme(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          AppSpacing.xxl,
        ),
        children: [
          InvoiceEditorHero(
            number: draft.number,
            totalMinor: form.totals.total,
            currencyCode: form.totals.currencyCode,
            issueDate: draft.issueDate.toLocalDateTime(),
            dueDate: draft.dueDate.toLocalDateTime(),
          ),
          const _Gap(),
          FormSection(
            title: l10n.sectionInvoiceDetails,
            child: InvoiceHeaderSection(form: form, vm: vm),
          ),
          const _Gap(),
          FormSection(
            title: l10n.sectionBillTo,
            child: BillToCard(
              billTo: draft.billTo,
              onChoose: () => _chooseClient(context, ref),
              onRemove: draft.billTo == null ? null : vm.clearClient,
            ),
          ),
          const _Gap(),
          FormSection(
            title: l10n.itemsTitle,
            child: InvoiceLinesSection(
              form: form,
              onEditLine: (id) => _editLine(context, ref, id),
              onAdd: () => _addLine(context, ref),
            ),
          ),
          const _Gap(),
          FormSection(
            title: l10n.sectionAdjustments,
            child: InvoiceAdjustmentsSection(form: form, vm: vm),
          ),
          const _Gap(),
          TotalsSummary(
            totals: form.totals,
            taxRateBasisPoints: draft.taxRateBasisPoints,
            taxInclusive: draft.taxInclusive,
          ),
          const _Gap(),
          FormSection(
            title: l10n.sectionNotesTerms,
            child: InvoiceNotesSection(form: form, vm: vm),
          ),
        ],
      ),
    );
  }
}

/// Space between two sections.
class _Gap extends StatelessWidget {
  const _Gap();

  @override
  Widget build(BuildContext context) => const SizedBox(height: AppSpacing.xl);
}
