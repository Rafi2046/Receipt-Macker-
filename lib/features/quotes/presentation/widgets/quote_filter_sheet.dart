import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/calendar_date.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/currency_picker_sheet.dart';
import '../../../../core/widgets/inputs/date_field.dart';
import '../../../clients/domain/models/client.dart';
import '../../../invoices/presentation/widgets/client_picker_sheet.dart';
import '../../domain/logic/quote_advanced_filters.dart';

/// Bottom sheet: client, currency, issue-date range.
class QuoteFilterSheet extends StatefulWidget {
  const QuoteFilterSheet({required this.initial, super.key});

  final QuoteAdvancedFilters initial;

  static Future<QuoteAdvancedFilters?> show(
    BuildContext context, {
    required QuoteAdvancedFilters initial,
  }) {
    return showModalBottomSheet<QuoteAdvancedFilters>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => QuoteFilterSheet(initial: initial),
    );
  }

  @override
  State<QuoteFilterSheet> createState() => _QuoteFilterSheetState();
}

class _QuoteFilterSheetState extends State<QuoteFilterSheet> {
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

  void _apply() {
    Navigator.of(context).pop(
      QuoteAdvancedFilters(
        clientId: _clientId,
        clientName: _clientName,
        currencyCode: _currencyCode,
        issueFrom: _issueFrom,
        issueTo: _issueTo,
      ),
    );
  }

  void _clear() {
    setState(() {
      _clientId = null;
      _clientName = null;
      _currencyCode = null;
      _issueFrom = null;
      _issueTo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final format = AppFormatters(Localizations.localeOf(context).languageCode);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.pagePadding,
        right: AppSpacing.pagePadding,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.quoteFilterBy,
                  textAlign: TextAlign.center,
                  style: context.textStyles.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(AppIcons.close),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _NavRow(
            label: l10n.quoteFilterClient,
            value: _clientName ?? l10n.quoteFilterAllClients,
            onTap: _pickClient,
          ),
          Divider(color: colors.border),
          _NavRow(
            label: l10n.quoteFilterCurrency,
            value: _currencyCode == null
                ? l10n.quoteFilterAllCurrencies
                : '${AppCurrencies.flag(_currencyCode!)} $_currencyCode',
            onTap: _pickCurrency,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            l10n.quoteFilterCreationDate,
            style: context.textStyles.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: DateField(
                  label: l10n.quoteFilterDateFrom,
                  value: _issueFrom?.toLocalDateTime(),
                  onChanged: (d) =>
                      setState(() => _issueFrom = CalendarDate.fromLocal(d)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DateField(
                  label: l10n.quoteFilterDateTo,
                  value: _issueTo?.toLocalDateTime(),
                  onChanged: (d) =>
                      setState(() => _issueTo = CalendarDate.fromLocal(d)),
                ),
              ),
            ],
          ),
          if (_issueFrom != null || _issueTo != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              [
                if (_issueFrom != null) format.calendarDate(_issueFrom!),
                if (_issueTo != null) format.calendarDate(_issueTo!),
              ].join(' – '),
              style: context.textStyles.bodySmall?.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: l10n.quoteFilterApply,
            expand: true,
            onPressed: _apply,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            label: l10n.quoteFilterClear,
            expand: true,
            variant: AppButtonVariant.secondary,
            onPressed: _clear,
          ),
        ],
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  const _NavRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          children: [
            Expanded(child: Text(label, style: context.textStyles.bodyLarge)),
            Text(
              value,
              style: context.textStyles.bodyMedium?.copyWith(
                color: colors.textSecondary,
              ),
            ),
            Icon(AppIcons.chevronRight, color: colors.textSecondary),
          ],
        ),
      ),
    );
  }
}
