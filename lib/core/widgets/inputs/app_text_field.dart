import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Labelled text input. Owns its controller unless one is passed in;
/// [initialValue] is used only for the first build.
/// Validation lives in the ViewModel; pass the result as [errorText].
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    this.controller,
    this.initialValue,
    this.hint,
    this.errorText,
    this.onChanged,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixIcon,
    this.prefixText,
    this.maxLines = 1,
    this.enabled = true,
    this.autofillHints,
    super.key,
  });

  final String label;
  final TextEditingController? controller;
  final String? initialValue;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final IconData? prefixIcon;
  final String? prefixText;
  final int maxLines;
  final bool enabled;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  TextEditingController? _owned;

  TextEditingController get _controller =>
      widget.controller ??
      (_owned ??= TextEditingController(text: widget.initialValue));

  @override
  void dispose() {
    _owned?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icon = widget.prefixIcon;
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      enabled: widget.enabled,
      autofillHints: widget.autofillHints,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        errorMaxLines: 3,
        prefixIcon: icon == null ? null : Icon(icon),
        prefixText: widget.prefixText,
      ),
    );
  }
}
