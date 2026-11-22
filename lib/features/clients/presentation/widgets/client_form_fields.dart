import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/buttons/more_fields_toggle.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/logic/client_field_access.dart';
import '../../domain/logic/client_validator.dart';
import '../../domain/models/client_field.dart';
import '../view_models/client_editor_state.dart';

/// Client editor: import, primary + billing, then expandable extra fields.
class ClientFormFields extends StatelessWidget {
  const ClientFormFields({
    required this.form,
    required this.onChanged,
    required this.onImportFromContacts,
    required this.onToggleMoreFields,
    super.key,
  });

  final ClientEditorState form;
  final void Function(ClientField field, String value) onChanged;
  final VoidCallback onImportFromContacts;
  final VoidCallback onToggleMoreFields;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pagePadding),
      children: [
        Center(
          child: AppButton(
            label: l10n.clientImportFromContacts,
            icon: AppIcons.clientAdd,
            variant: AppButtonVariant.secondary,
            onPressed: form.isBusy ? null : onImportFromContacts,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _FieldCard(
          form: form,
          onChanged: onChanged,
          fields: const [
            ClientField.name,
            ClientField.phone,
            ClientField.email,
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _FieldCard(
          title: l10n.fieldBillingAddress,
          form: form,
          onChanged: onChanged,
          fields: const [ClientField.address, ClientField.addressLine2],
          unlabeled: true,
        ),
        if (form.showMoreFields) ...[
          const SizedBox(height: AppSpacing.md),
          _FieldCard(
            title: l10n.fieldShippingAddress,
            form: form,
            onChanged: onChanged,
            fields: const [
              ClientField.shippingAddress,
              ClientField.shippingAddressLine2,
            ],
            unlabeled: true,
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldCard(
            form: form,
            onChanged: onChanged,
            fields: const [
              ClientField.taxRegistrationName,
              ClientField.taxRegistrationNumber,
              ClientField.licenseNumber,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _FieldCard(
            form: form,
            onChanged: onChanged,
            fields: const [ClientField.notes],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        MoreFieldsToggle(
          expanded: form.showMoreFields,
          onPressed: onToggleMoreFields,
        ),
      ],
    );
  }
}

class _FieldCard extends StatelessWidget {
  const _FieldCard({
    required this.form,
    required this.fields,
    required this.onChanged,
    this.title,
    this.unlabeled = false,
  });

  final ClientEditorState form;
  final List<ClientField> fields;
  final void Function(ClientField field, String value) onChanged;
  final String? title;
  final bool unlabeled;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: context.textStyles.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          for (var i = 0; i < fields.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.md),
            _ClientTextField(
              form: form,
              field: fields[i],
              onChanged: onChanged,
              hideLabel: unlabeled,
            ),
          ],
        ],
      ),
    );
  }
}

class _ClientTextField extends StatelessWidget {
  const _ClientTextField({
    required this.form,
    required this.field,
    required this.onChanged,
    this.hideLabel = false,
  });

  final ClientEditorState form;
  final ClientField field;
  final void Function(ClientField field, String value) onChanged;
  final bool hideLabel;

  static const int _multiLines = 3;

  bool get _multiline =>
      field == ClientField.address ||
      field == ClientField.shippingAddress ||
      field == ClientField.notes;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (label, hint) = _labels(l10n);
    return AppTextField(
      key: ValueKey('${field.name}_${form.formRevision}'),
      label: hideLabel ? '' : label,
      hint: hint,
      initialValue: form.draft.valueOf(field),
      errorText: l10n.validationMessage(form.errorFor(field)),
      prefixIcon: hideLabel ? null : _icon,
      maxLines: field == ClientField.notes ? 4 : (_multiline ? _multiLines : 1),
      maxLength: field == ClientField.notes ? ClientValidator.maxNotes : null,
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
    ClientField.phone => (l10n.fieldPhone, l10n.fieldOptional),
    ClientField.email => (l10n.fieldEmail, l10n.fieldOptional),
    ClientField.address ||
    ClientField.addressLine2 ||
    ClientField.shippingAddress ||
    ClientField.shippingAddressLine2 => (l10n.fieldAddress, l10n.fieldOptional),
    ClientField.taxRegistrationName => (
      l10n.fieldTaxRegistrationName,
      l10n.fieldOptional,
    ),
    ClientField.taxRegistrationNumber => (
      l10n.fieldTaxRegistrationNumber,
      l10n.fieldOptional,
    ),
    ClientField.licenseNumber => (l10n.fieldLicenseNumber, l10n.fieldOptional),
    ClientField.notes => (l10n.fieldClientDetail, l10n.fieldClientDetailHint),
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
    ClientField.name ||
    ClientField.address ||
    ClientField.addressLine2 ||
    ClientField.shippingAddress ||
    ClientField.shippingAddressLine2 ||
    ClientField.taxRegistrationName => TextCapitalization.words,
    ClientField.notes => TextCapitalization.sentences,
    _ => TextCapitalization.none,
  };
}
