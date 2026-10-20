import 'package:flutter/material.dart';

import '../../constants/app_constants.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../../utils/formatters.dart';
import 'reveal_on_error.dart';

/// Read-only field that opens the date picker. Shows the date in the UI
/// language (Bangla digits in Bangla). Reports a local calendar date.
class DateField extends StatelessWidget {
  const DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    super.key,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String? errorText;
  final bool enabled;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(AppConstants.minPickerYear),
      lastDate: DateTime(AppConstants.maxPickerYear),
      helpText: context.l10n.selectDate,
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final date = value;
    final text = date == null
        ? ''
        : AppFormatters(Localizations.localeOf(context).languageCode)
              .date(date);
    return RevealOnError(
      errorText: errorText,
      child: Semantics(
        button: true,
        child: InkWell(
          borderRadius: AppRadius.input,
          onTap: enabled ? () => _pick(context) : null,
          child: InputDecorator(
            isEmpty: date == null,
            decoration: InputDecoration(
              labelText: label,
              errorText: errorText,
              enabled: enabled,
              suffixIcon: const Icon(AppIcons.date),
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
