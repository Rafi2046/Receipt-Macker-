import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/percent_field.dart';

/// Edits the default tax rate. Returns the result in [TaxRatePick], or
/// null when dismissed. An empty field means no default tax.
abstract final class TaxRateSheet {
  static Future<TaxRatePick?> show(
    BuildContext context, {
    required int? basisPoints,
  }) {
    return showModalBottomSheet<TaxRatePick>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: context.appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxl),
        ),
      ),
      builder: (_) => _Body(initial: basisPoints),
    );
  }
}

/// The saved rate; null means no default tax.
typedef TaxRatePick = ({int? basisPoints});

class _Body extends StatefulWidget {
  const _Body({required this.initial});

  final int? initial;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  late int? _value = widget.initial;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        0,
        AppSpacing.pagePadding,
        AppSpacing.xxl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.lg,
        children: [
          Text(
            l10n.settingsTaxRate,
            style: context.textStyles.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          PercentField(
            label: l10n.settingsTaxRate,
            basisPoints: _value,
            onChanged: (v) => _value = v,
          ),
          AppButton(
            label: l10n.save,
            expand: true,
            onPressed: () => Navigator.of(context).pop((basisPoints: _value)),
          ),
        ],
      ),
    );
  }
}
