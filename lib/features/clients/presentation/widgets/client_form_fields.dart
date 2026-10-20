import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/logic/client_field_access.dart';
import '../../domain/models/client_field.dart';
import '../view_models/client_editor_state.dart';

/// The client editor's fields, in a scrollable page.
class ClientFormFields extends StatelessWidget {
  const ClientFormFields({
    required this.form,
    required this.onChanged,
    super.key,
  });

  final ClientEditorState form;
  final void Function(ClientField field, String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        for (final field in ClientField.values) ...[
          _ClientTextField(form: form, field: field, onChanged: onChanged),
          const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }
}

class _ClientTextField extends StatelessWidget {
  const _ClientTextField({
    required this.form,
    required this.field,
    required this.onChanged,
  });

  final ClientEditorState form;
  final ClientField field;
  final void Function(ClientField field, String value) onChanged;

  static const int _multiLines = 3;

  bool get _multiline =>
      field == ClientField.address || field == ClientField.notes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, hint) = _labels(l10n);
    return AppTextField(
      key: ValueKey(field),
      label: label,
      hint: hint,
      initialValue: form.draft.valueOf(field),
      errorText: l10n.validationMessage(form.errorFor(field)),
      prefixIcon: _icon,
      maxLines: _multiline ? _multiLines : 1,
      keyboardType: _keyboard,
      textCapitalization: _capitalization,
      textInputAction: _multiline
          ? TextInputAction.newline
          : TextInputAction.next,
      onChanged: (v) => onChanged(field, v),
    );
  }

  (String, String?) _labels(AppLocalizations l10n) => switch (field) {
    ClientField.name => (l10n.fieldClientName, l10n.fieldClientNameHint),
    ClientField.phone => (l10n.fieldPhone, null),
    ClientField.email => (l10n.fieldEmail, null),
    ClientField.address => (l10n.fieldAddress, null),
    ClientField.notes => (l10n.fieldNotes, l10n.fieldNotesHint),
  };

  IconData? get _icon => switch (field) {
    ClientField.name => AppIcons.client,
    ClientField.phone => AppIcons.phone,
    ClientField.email => AppIcons.email,
    _ => null,
  };

  TextInputType get _keyboard => switch (field) {
    ClientField.phone => TextInputType.phone,
    ClientField.email => TextInputType.emailAddress,
    _ when _multiline => TextInputType.multiline,
    _ => TextInputType.text,
  };

  TextCapitalization get _capitalization => switch (field) {
    ClientField.name || ClientField.address => TextCapitalization.words,
    ClientField.notes => TextCapitalization.sentences,
    _ => TextCapitalization.none,
  };
}
