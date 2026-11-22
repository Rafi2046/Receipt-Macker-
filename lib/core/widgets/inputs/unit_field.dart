import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'unit_picker_sheet.dart';

/// Picks a unit of measure ("pcs", "hour"…) from common ones, or one the
/// user types. The unit is plain text; empty means none.
class UnitField extends StatelessWidget {
  const UnitField({
    required this.value,
    required this.onChanged,
    this.maxLength = 20,
    this.errorText,
    super.key,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final int maxLength;
  final String? errorText;

  Future<void> _open(BuildContext context) async {
    final picked = await showUnitPicker(
      context,
      current: value,
      maxLength: maxLength,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: () => _open(context),
      child: InputDecorator(
        isEmpty: value.isEmpty,
        decoration: InputDecoration(
          hintText: context.l10n.fieldOptional,
          errorText: errorText,
          suffixIcon: Icon(AppIcons.dropdown, color: colors.textSecondary),
        ),
        child: value.isEmpty
            ? null
            : Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.bodyLarge?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
      ),
    );
  }
}
