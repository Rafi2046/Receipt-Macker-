import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/buttons/app_icon_button.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import '../../domain/models/bill_to.dart';
import 'editor_add_dot.dart';

/// Who the invoice is from (the business) and who it is for (the client).
class InvoicePartiesCard extends StatelessWidget {
  const InvoicePartiesCard({
    required this.businessName,
    required this.billTo,
    required this.onBusiness,
    required this.onChooseClient,
    required this.onRemoveClient,
    super.key,
  });

  /// Empty when the business profile has no name yet.
  final String businessName;
  final BillTo? billTo;
  final VoidCallback onBusiness;
  final VoidCallback onChooseClient;
  final VoidCallback onRemoveClient;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final bill = billTo;
    final hasBusiness = businessName.trim().isNotEmpty;
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EditorRow(
            icon: AppIcons.business,
            tone: colors.info,
            title: l10n.editorBillFrom,
            subtitle: hasBusiness ? businessName : l10n.editorAddBusiness,
            trailing: hasBusiness ? null : const EditorAddDot(),
            onTap: onBusiness,
          ),
          const Divider(
            height: AppSizes.borderWidth,
            indent: AppSpacing.lg + AppSizes.avatarMd + AppSpacing.md,
            endIndent: AppSpacing.lg,
          ),
          EditorRow(
            icon: AppIcons.clients,
            tone: colors.warning,
            title: l10n.sectionBillTo,
            subtitle: bill == null
                ? l10n.editorAddClient
                : _summary(context, bill),
            trailing: bill == null
                ? const EditorAddDot()
                : AppIconButton(
                    icon: AppIcons.close,
                    semanticLabel: l10n.remove,
                    onPressed: onRemoveClient,
                  ),
            onTap: onChooseClient,
          ),
        ],
      ),
    );
  }

  static String _summary(BuildContext context, BillTo bill) {
    final digits = AppFormatters(Localizations.localeOf(context).languageCode);
    final contact = digits.localizeDigits(
      [bill.phone, bill.email].where((s) => s.isNotEmpty).join(' · '),
    );
    return contact.isEmpty ? bill.name : '${bill.name}\n$contact';
  }
}
