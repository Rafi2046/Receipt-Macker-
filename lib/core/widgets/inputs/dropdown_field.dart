import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import 'reveal_on_error.dart';

/// Labelled single-choice picker. [options] pairs each value with its label.
class DropdownField<T> extends StatelessWidget {
  const DropdownField({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.errorText,
    super.key,
  });

  final String label;
  final List<(T, String)> options;
  final T? value;
  final ValueChanged<T> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return RevealOnError(
      errorText: errorText,
      child: DropdownButtonFormField<T>(
        // Rebuild when the value changes from outside (initialValue is read once).
        key: ValueKey(value),
        initialValue: value,
        isExpanded: true,
        // Same size as text fields (the default is a title style).
        style: context.textStyles.bodyLarge?.copyWith(
          color: context.appColors.textPrimary,
        ),
        icon: const Icon(AppIcons.dropdown),
        decoration: InputDecoration(labelText: label, errorText: errorText),
        items: [
          for (final (v, text) in options)
            DropdownMenuItem<T>(
              value: v,
              child: Text(text, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
      ),
    );
  }
}
