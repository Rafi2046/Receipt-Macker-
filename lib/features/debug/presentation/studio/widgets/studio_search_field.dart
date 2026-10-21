import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../studio_icons.dart';
import '../studio_scope.dart';
import 'studio_card.dart';

/// Filled search field sitting on a card.
class StudioSearchField extends StatelessWidget {
  const StudioSearchField({
    required this.hint,
    required this.onChanged,
    super.key,
  });

  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final palette = context.studio;
    final type = context.studioType;
    return DecoratedBox(
      decoration: studioCardDecoration(palette),
      child: TextField(
        onChanged: onChanged,
        style: type.body(palette.ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: type.body(palette.muted),
          prefixIcon: Icon(
            StudioIcons.search,
            color: palette.muted,
            size: AppSizes.iconMd,
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
      ),
    );
  }
}
