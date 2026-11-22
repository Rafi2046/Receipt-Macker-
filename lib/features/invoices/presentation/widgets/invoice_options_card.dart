import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import '../../domain/models/invoice.dart';

/// Currency, payment method, signature and terms: one row each, showing
/// what is set.
class InvoiceOptionsCard extends StatelessWidget {
  const InvoiceOptionsCard({
    required this.draft,
    required this.hasSignature,
    required this.onCurrency,
    required this.onPayment,
    required this.onSignature,
    required this.onNotes,
    super.key,
  });

  final Invoice draft;
  final bool hasSignature;
  final VoidCallback onCurrency;
  final VoidCallback onPayment;
  final VoidCallback onSignature;
  final VoidCallback onNotes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    // Payments are in the invoice's currency; it cannot change after one.
    final currencyLocked = draft.paidMinor > 0;
    String? firstLine(String s) {
      final line = s.trim().split('\n').first.trim();
      return line.isEmpty ? null : line;
    }

    final rows = [
      EditorRow(
        icon: AppIcons.currency,
        title: l10n.fieldCurrency,
        subtitle: currencyLocked ? l10n.currencyLockedHint : null,
        value:
            '${AppCurrencies.flag(draft.currencyCode)} ${draft.currencyCode}',
        trailing: currencyLocked
            ? Icon(AppIcons.lock, color: context.appColors.textSecondary)
            : null,
        onTap: currencyLocked ? null : onCurrency,
      ),
      EditorRow(
        icon: AppIcons.paymentMethod,
        title: l10n.editorPaymentMethod,
        value: firstLine(draft.paymentInstructions),
        onTap: onPayment,
      ),
      EditorRow(
        icon: AppIcons.signature,
        title: l10n.signatureTitle,
        value: hasSignature ? l10n.editorAdded : null,
        onTap: onSignature,
      ),
      EditorRow(
        icon: AppIcons.notes,
        title: l10n.editorTermsNotes,
        value: firstLine(draft.terms) ?? firstLine(draft.notes),
        onTap: onNotes,
      ),
    ];
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, row) in rows.indexed) ...[
            if (i > 0)
              const Divider(
                height: AppSizes.borderWidth,
                indent: AppSpacing.lg + AppSizes.iconMd + AppSpacing.md,
                endIndent: AppSpacing.lg,
              ),
            row,
          ],
        ],
      ),
    );
  }
}
