import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/status_chip.dart';
import '../../domain/models/invoice_status.dart';

/// The invoice status as a labelled chip: draft = neutral, sent = info,
/// partially paid = warning, paid = success, overdue = danger.
class InvoiceStatusChip extends StatelessWidget {
  const InvoiceStatusChip({required this.status, super.key});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, tone) = switch (status) {
      InvoiceStatus.draft => (l10n.statusDraft, StatusTone.neutral),
      InvoiceStatus.sent => (l10n.statusSent, StatusTone.info),
      InvoiceStatus.partiallyPaid => (
        l10n.statusPartiallyPaid,
        StatusTone.warning,
      ),
      InvoiceStatus.paid => (l10n.statusPaid, StatusTone.success),
      InvoiceStatus.overdue => (l10n.statusOverdue, StatusTone.danger),
    };
    return StatusChip(label: label, tone: tone);
  }
}
