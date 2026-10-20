import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../buttons/app_icon_button.dart';

/// Search box for list screens, with a clear button once text is entered.
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
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) => TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: const Icon(AppIcons.search),
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
