import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_currencies.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../../utils/formatters.dart';
import 'app_search_field.dart';

/// Opens a searchable currency list. Returns the chosen code, or null.
Future<String?> showCurrencyPicker({
  required BuildContext context,
  required String selectedCode,
  required List<String> codes,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.appColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.xxl)),
    ),
    builder: (context) =>
        _CurrencyPickerSheet(selectedCode: selectedCode, codes: codes),
  );
}

class _CurrencyPickerSheet extends StatefulWidget {
  const _CurrencyPickerSheet({required this.selectedCode, required this.codes});

  final String selectedCode;
  final List<String> codes;

  @override
  State<_CurrencyPickerSheet> createState() => _CurrencyPickerSheetState();
}

class _CurrencyPickerSheetState extends State<_CurrencyPickerSheet> {
  var _query = '';

  List<String> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.codes;
    return [
      for (final code in widget.codes)
        if (code.toLowerCase().contains(q) ||
            AppCurrencies.name(code).toLowerCase().contains(q) ||
            AppFormatters.currencySymbol(code).toLowerCase().contains(q))
          code,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final height = MediaQuery.sizeOf(context).height * 0.72;
    final filtered = _filtered;
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Container(
              width: AppSpacing.xxxl,
              height: AppSpacing.xs,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: AppRadius.chip,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.lg,
              AppSpacing.pagePadding,
              AppSpacing.sm,
            ),
            child: Text(
              l10n.currencyPickerTitle,
              style: context.textStyles.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.pagePadding,
            ),
            child: AppSearchField(
              hint: l10n.currencySearchHint,
              onChanged: (q) => setState(() => _query = q),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      l10n.searchNoResultsTitle,
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.pagePadding,
                      AppSpacing.sm,
                      AppSpacing.pagePadding,
                      AppSpacing.xxl,
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, i) {
                      final code = filtered[i];
                      return _CurrencyTile(
                        code: code,
                        selected: code == widget.selectedCode,
                        onTap: () => Navigator.of(context).pop(code),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.code,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final symbol = AppFormatters.currencySymbol(code);
    return Material(
      color: selected
          ? colors.primary.withValues(alpha: 0.1)
          : colors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppSpacing.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              _FlagBadge(flag: AppCurrencies.flag(code)),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code,
                      style: context.textStyles.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: selected ? colors.primary : colors.textPrimary,
                      ),
                    ),
                    Text(
                      AppCurrencies.name(code),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                symbol,
                style: context.textStyles.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: selected ? colors.primary : colors.textPrimary,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: AppSpacing.sm),
                Icon(AppIcons.check, color: colors.primary),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  const _FlagBadge({required this.flag});

  final String flag;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: context.appColors.border),
      ),
      child: SizedBox.square(
        dimension: AppSizes.avatarMd,
        child: Center(child: Text(flag, style: const TextStyle(fontSize: 20))),
      ),
    );
  }
}
