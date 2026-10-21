import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../studio_scope.dart';

/// Section title inside invoice settings.
class StudioSettingsHeading extends StatelessWidget {
  const StudioSettingsHeading(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(label, style: context.studioType.titleSm(context.studio.ink)),
    );
  }
}
