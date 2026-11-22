import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/document_filters.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/currency_picker_sheet.dart';
import '../../../../core/widgets/inputs/date_field.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import '../../../clients/domain/models/client.dart';
import 'client_picker_sheet.dart';

/// Filters for a document list (invoices, estimates): client, currency
/// and issue-date range. Returns the new filters, or null if dismissed.
class DocumentFilterSheet extends StatefulWidget {
  const DocumentFilterSheet({required this.initial, super.key});

  final DocumentFilters initial;

  static Future<DocumentFilters?> show(
    BuildContext context, {
    required DocumentFilters initial,
  }) {
    return showModalBottomSheet<DocumentFilters>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: context.appColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxl),
        ),
      ),
      builder: (_) => DocumentFilterSheet(initial: initial),
    );
  }

  @override
  State<DocumentFilterSheet> createState() => _DocumentFilterSheetState();
}

class _DocumentFilterSheetState extends State<DocumentFilterSheet> {
  late String? _clientId = widget.initial.clientId;
  late String? _clientName = widget.initial.clientName;
  late String? _currencyCode = widget.initial.currencyCode;
  late CalendarDate? _issueFrom = widget.initial.issueFrom;
  late CalendarDate? _issueTo = widget.initial.issueTo;

  Future<void> _pickClient() async {
    final Client? client = await ClientPickerSheet.show(context);
    if (client == null || !mounted) return;
    setState(() {
      _clientId = client.id;
      _clientName = client.name;
    });
  }

  Future<void> _pickCurrency() async {
    final code = await showCurrencyPicker(
      context: context,
      selectedCode: _currencyCode ?? AppCurrencies.common.first,
      codes: AppCurrencies.common,
    );
    if (code == null || !mounted) return;
    setState(() => _currencyCode = code);
  }

  void _apply() => Navigator.of(context).pop(
    DocumentFilters(
      clientId: _clientId,
      clientName: _clientName,
      currencyCode: _currencyCode,
      issueFrom: _issueFrom,
      issueTo: _issueTo,
    ),
  );

  void _reset() => setState(() {
    _clientId = null;
    _clientName = null;
    _currencyCode = null;
    _issueFrom = null;
    _issueTo = null;
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currency = _currencyCode;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        0,
        AppSpacing.pagePadding,
        AppSpacing.xxl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.quoteFilterBy,
                  style: context.textStyles.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(onPressed: _reset, child: Text(l10n.quoteFilterClear)),
            ],
          ),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                EditorRow(
                  icon: AppIcons.client,
                  iconSize: AppSizes.iconRow,
                  title: l10n.quoteFilterClient,
                  value: _clientName ?? l10n.quoteFilterAllClients,
                  onTap: _pickClient,
                ),
                const Divider(height: AppSizes.borderWidth),
                EditorRow(
                  icon: AppIcons.currency,
                  iconSize: AppSizes.iconRow,
                  title: l10n.quoteFilterCurrency,
                  value: currency == null
                      ? l10n.quoteFilterAllCurrencies
                      : '${AppCurrencies.flag(currency)} $currency',
                  onTap: _pickCurrency,
                ),
              ],
            ),
          ),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSpacing.md,
              children: [
                Text(
                  l10n.quoteFilterCreationDate,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Expanded(
                      child: DateField(
                        label: l10n.quoteFilterDateFrom,
                        value: _issueFrom?.toLocalDateTime(),
                        onChanged: (d) => setState(
                          () => _issueFrom = CalendarDate.fromLocal(d),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DateField(
                        label: l10n.quoteFilterDateTo,
                        value: _issueTo?.toLocalDateTime(),
                        onChanged: (d) => setState(
                          () => _issueTo = CalendarDate.fromLocal(d),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: l10n.quoteFilterApply,
            expand: true,
            onPressed: _apply,
          ),
        ],
      ),
    );
  }
}
