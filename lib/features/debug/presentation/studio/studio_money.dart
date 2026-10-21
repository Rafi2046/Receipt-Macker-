import 'package:flutter/widgets.dart';

import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';

AppFormatters studioFormat(BuildContext context) =>
    AppFormatters(Localizations.localeOf(context).languageCode);

String studioMoney(BuildContext context, int minor) =>
    studioFormat(context).currency(minor, 'BDT');

String studioDueLabel(BuildContext context, int days) {
  final l10n = context.l10n;
  final count = studioFormat(context).integer(days.abs());
  if (days < 0) return l10n.studioOverdueDays(count);
  if (days == 0) return l10n.studioDueToday;
  return l10n.studioDueInDays(count);
}

String studioSignedPercent(BuildContext context, int percent) {
  final digits = studioFormat(context).integer(percent.abs());
  final sign = percent < 0 ? '−' : '+';
  return '$sign$digits${context.l10n.percentSymbol}';
}
