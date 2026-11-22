import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_spacing.dart';

/// A field with its label above it, and a star when it is [required].
/// Give the field itself an empty label and wrap the form in a
/// `SoftInputTheme` with `SoftInputStyle.boxed`.
class FieldBlock extends StatelessWidget {
  const FieldBlock({
    required this.label,
    required this.child,
    this.required = false,
    super.key,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = context.textStyles.labelLarge?.copyWith(
      color: colors.textPrimary,
      fontWeight: FontWeight.w600,
    );
    return Semantics(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.sm,
        children: [
          ExcludeSemantics(
            child: Text.rich(
              TextSpan(
                text: label,
                children: [
                  if (required)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: colors.danger),
                    ),
                ],
              ),
              style: style,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
