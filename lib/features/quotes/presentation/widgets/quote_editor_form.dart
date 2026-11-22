import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../../../core/widgets/pdf/template_picker_card.dart';
import '../../../business_profile/business_profile.dart';
import '../../../invoices/presentation/widgets/bill_to_card.dart';
import '../../../invoices/presentation/widgets/client_picker_sheet.dart';
import '../../../invoices/presentation/widgets/item_pick.dart';
import '../../../invoices/presentation/widgets/item_picker_sheet.dart';
import '../../domain/models/quote_status.dart';
import '../view_models/quote_editor_state.dart';
import '../view_models/quote_editor_view_model.dart';
import 'quote_adjustments_section.dart';
import 'quote_header_card.dart';
import 'quote_line_sheet.dart';
import 'quote_notes_section.dart';

class QuoteEditorForm extends ConsumerWidget {
  const QuoteEditorForm({required this.quoteId, required this.form, super.key});

  final String? quoteId;
  final QuoteEditorState form;

  QuoteEditorViewModelProvider get _provider =>
      quoteEditorViewModelProvider(quoteId);

  Future<void> _pickClient(BuildContext context, WidgetRef ref) async {
    final client = await ClientPickerSheet.show(context);
    if (client == null) return;
    ref.read(_provider.notifier).setClient(client);
  }

  Future<void> _addItem(BuildContext context, WidgetRef ref) async {
    final pick = await ItemPickerSheet.show(context);
    if (pick == null || !context.mounted) return;
    final vm = ref.read(_provider.notifier);
    switch (pick) {
      case SavedItemPick(:final item):
        vm.addItem(item);
      case OneOffItemPick():
        final id = vm.addBlankLine();
        final blank = ref
            .read(_provider)
            .value
            ?.draft
            .lines
            .where((l) => l.id == id)
            .firstOrNull;
        if (blank == null || !context.mounted) return;
        final edited = await QuoteLineSheet.show(
          context,
          line: blank,
          currencyCode: form.draft.currencyCode,
        );
        if (edited != null) {
          vm.updateLine(edited);
        } else if (blank.name.trim().isEmpty) {
          vm.removeLine(id);
        }
    }
  }

  Future<void> _editLine(
    BuildContext context,
    WidgetRef ref,
    String lineId,
  ) async {
    final line = form.draft.lines.where((l) => l.id == lineId).firstOrNull;
    if (line == null) return;
    final edited = await QuoteLineSheet.show(
      context,
      line: line,
      currencyCode: form.draft.currencyCode,
    );
    if (edited != null) {
      ref.read(_provider.notifier).updateLine(edited);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final vm = ref.read(_provider.notifier);
    final draft = form.draft;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final profile = ref.watch(currentBusinessProfileProvider).value;
    final subtotal = vm.subtotalMinor();
    final total = vm.totalMinor();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        QuoteHeaderCard(draft: draft, vm: vm),
        const SizedBox(height: AppSpacing.md),
        const TemplatePickerCard(),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          onTap: () => context.pushNamed(RouteNames.businessProfile),
          child: Row(
            children: [
              Icon(AppIcons.business, color: colors.info),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.quoteBillFrom,
                      style: context.textStyles.labelMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      profile?.name.trim().isNotEmpty == true
                          ? profile!.name
                          : l10n.quoteAddBusiness,
                      style: context.textStyles.titleSmall,
                    ),
                  ],
                ),
              ),
              Icon(AppIcons.add, color: colors.primary),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        BillToCard(
          billTo: draft.billTo,
          onChoose: () => _pickClient(context, ref),
          onRemove: draft.billTo == null ? null : vm.clearClient,
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.quoteItems),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: () => _addItem(context, ref),
                icon: const Icon(AppIcons.add),
                label: Text(l10n.quoteAddItem),
              ),
              if (draft.lines.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Text(
                    l10n.quoteNoItems,
                    style: context.textStyles.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                )
              else
                for (final line in draft.lines)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () => _editLine(context, ref, line.id),
                    title: Text(line.name.isEmpty ? '—' : line.name),
                    subtitle: Text(
                      format.currency(line.unitPriceMinor, draft.currencyCode),
                    ),
                    trailing: IconButton(
                      icon: const Icon(AppIcons.delete),
                      onPressed: () => vm.removeLine(line.id),
                    ),
                  ),
              const Divider(),
              Row(
                children: [
                  Text(
                    l10n.totalSubtotal,
                    style: context.textStyles.bodyMedium,
                  ),
                  const Spacer(),
                  Text(
                    format.currency(subtotal, draft.currencyCode),
                    style: context.textStyles.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Text(
                    l10n.totalTotal,
                    style: context.textStyles.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    format.currency(total, draft.currencyCode),
                    style: context.textStyles.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.sectionAdjustments),
        AppCard(
          child: QuoteAdjustmentsSection(draft: draft, vm: vm),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.quoteSectionNotes),
        AppCard(
          child: QuoteNotesSection(draft: draft, vm: vm),
        ),
        const SizedBox(height: AppSpacing.lg),
        SectionHeader(title: l10n.quoteSectionStatus),
        AppCard(
          child: Wrap(
            spacing: AppSpacing.sm,
            children: [
              for (final status in QuoteStatus.values)
                ChoiceChip(
                  label: Text(switch (status) {
                    QuoteStatus.pending => l10n.quoteStatusPending,
                    QuoteStatus.approved => l10n.quoteStatusApproved,
                    QuoteStatus.rejected => l10n.quoteStatusCancelled,
                  }),
                  selected: draft.status == status,
                  onSelected: (_) => vm.setStatus(status),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),
      ],
    );
  }
}
