import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../buttons/app_icon_button.dart';

/// Pill-shaped search box for list screens, with a clear button once text
/// is entered.
class AppSearchField extends StatefulWidget {
  const AppSearchField({
    required this.hint,
    required this.onChanged,
    this.initialValue = '',
    super.key,
  });

  final String hint;
  final ValueChanged<String> onChanged;
  final String initialValue;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final pill = OutlineInputBorder(
      borderRadius: AppRadius.chip,
      borderSide: BorderSide(color: colors.border),
    );
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) => TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          border: pill,
          enabledBorder: pill,
          focusedBorder: pill.copyWith(
            borderSide: BorderSide(color: colors.primary),
          ),
          prefixIcon: Icon(AppIcons.search, color: colors.textSecondary),
          suffixIcon: value.text.isEmpty
              ? null
              : AppIconButton(
                  icon: AppIcons.close,
                  semanticLabel: context.l10n.clearSearch,
                  onPressed: _clear,
                ),
        ),
      ),
    );
  }
}
