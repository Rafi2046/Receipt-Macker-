import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../view_models/invoice_editor_state.dart';
import '../view_models/invoice_editor_view_model.dart';
import 'bill_to_card.dart';
import 'client_picker_sheet.dart';
import 'invoice_adjustments_section.dart';
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
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        AppSpacing.pagePadding,
        AppSpacing.pagePadding,
        AppSizes.fabClearance,
      ),
      children: [
        InvoiceHeaderSection(form: form, vm: vm),
        _Gap(title: l10n.sectionBillTo),
        BillToCard(
          billTo: draft.billTo,
          onChoose: () => _chooseClient(context, ref),
          onRemove: draft.billTo == null ? null : vm.clearClient,
        ),
        _Gap(title: l10n.itemsTitle),
        InvoiceLinesSection(
          form: form,
          onEditLine: (id) => _editLine(context, ref, id),
          onAdd: () => _addLine(context, ref),
        ),
        _Gap(title: l10n.sectionAdjustments),
        InvoiceAdjustmentsSection(form: form, vm: vm),
        const SizedBox(height: AppSpacing.sectionGap),
        TotalsSummary(
          totals: form.totals,
          taxRateBasisPoints: draft.taxRateBasisPoints,
          taxInclusive: draft.taxInclusive,
        ),
        _Gap(title: l10n.sectionNotesTerms),
        InvoiceNotesSection(form: form, vm: vm),
      ],
    );
  }
}

/// Section spacing and header.
class _Gap extends StatelessWidget {
  const _Gap({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: AppSpacing.sectionGap,
      bottom: AppSpacing.sm,
    ),
    child: SectionHeader(title: title),
  );
}
