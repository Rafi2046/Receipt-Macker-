import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';

/// Hairline separator. [spacing] is the total vertical space it takes.
class AppDivider extends StatelessWidget {
  const AppDivider({this.spacing = AppSpacing.lg, this.indent = 0, super.key});

  final double spacing;
  final double indent;

  @override
  Widget build(BuildContext context) =>
      Divider(height: spacing, indent: indent, endIndent: indent);
}
