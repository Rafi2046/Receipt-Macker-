import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/utils/extensions/l10n_extension.dart';
import '../studio_money.dart';
import '../studio_scope.dart';
import 'studio_page_header.dart';
import 'studio_settings_payments.dart';
import 'studio_settings_rules.dart';

/// Business defaults for new invoices. A single invoice can override them.
class StudioInvoiceSettingsView extends StatefulWidget {
  const StudioInvoiceSettingsView({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  State<StudioInvoiceSettingsView> createState() =>
      _StudioInvoiceSettingsViewState();
}

class _StudioInvoiceSettingsViewState extends State<StudioInvoiceSettingsView> {
  final TextEditingController _payment = TextEditingController();
  final TextEditingController _tax = TextEditingController();
  final TextEditingController _terms = TextEditingController();
  final TextEditingController _prefix = TextEditingController(text: 'INV');
  final TextEditingController _next = TextEditingController();
  var _seeded = false;
  var _inclusive = false;
  var _due = 2;
  var _currency = 0;
  var _paidStamp = false;
  var _totalQty = false;
  var _balance = true;
  var _splitQty = true;
  var _resetYearly = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    _seeded = true;
    final l10n = context.l10n;
    final format = studioFormat(context);
    _payment.text = format.localizeDigits(l10n.studioPaySample);
    _tax.text = format.integer(15);
    _terms.text = l10n.studioTermsSample;
    _next.text = format.localizeDigits('0006');
  }

  @override
  void dispose() {
    _payment.dispose();
    _tax.dispose();
    _terms.dispose();
    _prefix.dispose();
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ColoredBox(
      color: context.studio.background,
      child: Column(
        children: [
          StudioPageHeader(
            title: l10n.studioInvoiceSettings,
            onBack: widget.onBack,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.sm,
                AppSpacing.pagePadding,
                AppSpacing.xxl,
              ),
              children: [
                Text(
                  l10n.studioSettingsIntro,
                  style: context.studioType.secondary(context.studio.muted),
                ),
                const SizedBox(height: AppSpacing.lg),
                StudioSettingsPayments(
                  payment: _payment,
                  tax: _tax,
                  terms: _terms,
                  inclusive: _inclusive,
                  due: _due,
                  currency: _currency,
                  onInclusive: (index) =>
                      setState(() => _inclusive = index == 1),
                  onDue: (index) => setState(() => _due = index),
                  onCurrency: (index) => setState(() => _currency = index),
                ),
                const SizedBox(height: AppSpacing.lg),
                StudioSettingsRules(
                  prefix: _prefix,
                  next: _next,
                  paidStamp: _paidStamp,
                  totalQty: _totalQty,
                  balance: _balance,
                  splitQty: _splitQty,
                  resetYearly: _resetYearly,
                  onPaidStamp: (value) => setState(() => _paidStamp = value),
                  onTotalQty: (value) => setState(() => _totalQty = value),
                  onBalance: (value) => setState(() => _balance = value),
                  onSplitQty: (value) => setState(() => _splitQty = value),
                  onReset: (index) => setState(() => _resetYearly = index == 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
