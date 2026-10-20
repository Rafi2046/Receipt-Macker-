import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/formatters.dart';

enum AmountTextSize { md, lg }

/// Money from integer minor units, formatted for the UI language
/// (Bangla digits in Bangla), with tabular figures. Shrinks rather than
/// clipping when space is tight.
class AmountText extends StatelessWidget {
  const AmountText({
    required this.minor,
    required this.currencyCode,
    this.size = AmountTextSize.md,
    this.color,
    this.alignment = AlignmentDirectional.centerStart,
    super.key,
  });

  final int minor;
  final String currencyCode;
  final AmountTextSize size;
  final Color? color;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final formatter = AppFormatters(
      Localizations.localeOf(context).languageCode,
    );
    final base = size == AmountTextSize.lg
        ? AppTextStyles.amountLg
        : AppTextStyles.amountMd;
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignment,
      child: Text(
        formatter.currency(minor, currencyCode),
        maxLines: 1,
        style: base.copyWith(color: color ?? context.appColors.textPrimary),
      ),
    );
  }
}
