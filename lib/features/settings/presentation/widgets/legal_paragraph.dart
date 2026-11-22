import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// One point of a policy: a short heading and its paragraph.
typedef LegalSection = ({String title, String body});

/// A numbered heading over plain text, like a printed document.
class LegalParagraph extends StatelessWidget {
  const LegalParagraph({
    required this.number,
    required this.section,
    super.key,
  });

  /// Already localized (Bangla digits in Bangla).
  final String number;
  final LegalSection section;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          '$number. ${section.title}',
          style: context.textStyles.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          section.body,
          style: context.textStyles.bodyMedium?.copyWith(
            color: colors.textPrimary.withValues(alpha: 0.8),
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
