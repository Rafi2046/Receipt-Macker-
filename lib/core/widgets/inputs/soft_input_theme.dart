import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import 'soft_input_border.dart';

enum SoftInputStyle {
  /// No box at all: the field is a row inside a grouped card.
  row,

  /// A soft filled tile with the label inside it.
  tile,

  /// A rounded outline; the label sits above the field (see `FieldBlock`).
  boxed,
}

/// Restyles the inputs below it for long forms, where the default outlined
/// fields look heavy.
class SoftInputTheme extends StatelessWidget {
  const SoftInputTheme({
    required this.child,
    this.style = SoftInputStyle.row,
    super.key,
  });

  final Widget child;
  final SoftInputStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.inputDecorationTheme;
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: switch (style) {
          SoftInputStyle.row => _row(base),
          SoftInputStyle.tile => _tile(base, context.appColors),
          SoftInputStyle.boxed => _boxed(base, context.appColors),
        },
      ),
      child: child,
    );
  }

  static InputDecorationThemeData _row(InputDecorationThemeData base) =>
      base.copyWith(
        filled: false,
        isDense: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
      );

  static InputDecorationThemeData _tile(
    InputDecorationThemeData base,
    AppColors colors,
  ) {
    SoftInputBorder edge(Color color, [double width = AppSizes.borderWidth]) =>
        SoftInputBorder(
          borderRadius: AppRadius.card,
          borderSide: BorderSide(color: color, width: width),
        );
    final rest = edge(colors.surfaceAlt);
    return base.copyWith(
      filled: true,
      isDense: true,
      fillColor: colors.surfaceAlt,
      border: rest,
      enabledBorder: rest,
      disabledBorder: rest,
      focusedBorder: edge(colors.primary, AppSizes.selectedBorderWidth),
      errorBorder: edge(colors.danger),
      focusedErrorBorder: edge(colors.danger, AppSizes.selectedBorderWidth),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    );
  }

  static InputDecorationThemeData _boxed(
    InputDecorationThemeData base,
    AppColors colors,
  ) {
    OutlineInputBorder edge(
      Color color, [
      double width = AppSizes.borderWidth,
    ]) => OutlineInputBorder(
      borderRadius: AppRadius.card,
      borderSide: BorderSide(color: color, width: width),
    );
    final rest = edge(colors.border);
    return base.copyWith(
      filled: false,
      isDense: false,
      border: rest,
      enabledBorder: rest,
      disabledBorder: rest,
      focusedBorder: edge(colors.primary, AppSizes.selectedBorderWidth),
      errorBorder: edge(colors.danger),
      focusedErrorBorder: edge(colors.danger, AppSizes.selectedBorderWidth),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
    );
  }
}
