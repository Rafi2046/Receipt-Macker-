import 'package:flutter/material.dart';

import '../../../../../core/constants/app_spacing.dart';
import '../studio_scope.dart';
import 'studio_card.dart';

/// A labeled text field on a studio card.
class StudioSettingsField extends StatelessWidget {
  const StudioSettingsField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.suffix,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.studioType.label(palette.muted)),
        const SizedBox(height: AppSpacing.xs),
        DecoratedBox(
          decoration: studioCardDecoration(palette),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: context.studioType.body(palette.ink),
            decoration: InputDecoration(
              suffixText: suffix,
              suffixStyle: context.studioType.body(palette.muted),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.all(AppSpacing.md),
            ),
          ),
        ),
      ],
    );
  }
}
