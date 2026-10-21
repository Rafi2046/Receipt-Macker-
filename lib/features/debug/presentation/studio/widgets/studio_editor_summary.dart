import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_money.dart';
import '../studio_scope.dart';

/// Sticky totals and the save action. Sits below the form, never over a field.
class StudioEditorSummary extends StatelessWidget {
  const StudioEditorSummary({super.key});

  static const int subtotalMinor = 820000;
  static const int taxMinor = 110700;
  static const int totalMinor = 863700;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final l10n = context.l10n;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(top: BorderSide(color: palette.line)),
        boxShadow: palette.barShadows,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pagePadding,
            AppSpacing.md,
            AppSpacing.pagePadding,
            AppSpacing.sm,
          ),
          child: Column(
            children: [
              _Line(label: l10n.totalSubtotal, minor: subtotalMinor),
              _Line(
                label: l10n.totalTax(studioFormat(context).percent(1500)),
                minor: taxMinor,
              ),
              const SizedBox(height: AppSpacing.xs),
              _Line(label: l10n.totalTotal, minor: totalMinor, strong: true),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: palette.accent,
                    foregroundColor: palette.onAccent,
                    textStyle: context.studioType.titleSm(palette.onAccent),
                  ),
                  child: Text(l10n.studioSavePreview),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.label, required this.minor, this.strong = false});

  final String label;
  final int minor;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final type = context.studioType;
    final color = strong ? palette.ink : palette.muted;
    return Row(
      children: [
        Expanded(child: Text(label, style: type.body(color))),
        Text(
          studioMoney(context, minor),
          style: strong ? type.amount(palette.ink) : type.amountSm(color),
        ),
      ],
    );
  }
}
