import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_spacing.dart';
import '../../constants/app_text_styles.dart';

/// A small caption above a group of form fields.
class FormSection extends StatelessWidget {
  const FormSection({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppSpacing.xs,
            bottom: AppSpacing.sm,
          ),
          child: Semantics(
            header: true,
            child: Text(
              title.toUpperCase(),
              style: AppTextStyles.overline.copyWith(
                color: context.appColors.textSecondary,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
