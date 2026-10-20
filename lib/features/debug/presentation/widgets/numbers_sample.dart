import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/formatters.dart';

/// Formatted numbers and dates in the current UI language.
class NumbersSample extends StatelessWidget {
  const NumbersSample({super.key});

  static const int _sampleCount = 1234567;
  static const int _sampleMinor = 12345678;
  static const String _sampleDigits = '0123456789';
  static const String _takaSign = '৳';

  @override
  Widget build(BuildContext context) {
    final f = AppFormatters(Localizations.localeOf(context).languageCode);
    final color = context.appColors.textPrimary;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$_takaSign ${f.minorUnits(_sampleMinor, decimalDigits: 2)}',
          style: AppTextStyles.amountLg.copyWith(color: color),
        ),
        Text(
          f.integer(_sampleCount),
          style: AppTextStyles.amountMd.copyWith(color: color),
        ),
        Text(
          f.localizeDigits(_sampleDigits),
          style: AppTextStyles.amountMd.copyWith(color: color),
        ),
        Text(f.date(DateTime.now()), style: context.textStyles.bodyMedium),
      ],
    );
  }
}
