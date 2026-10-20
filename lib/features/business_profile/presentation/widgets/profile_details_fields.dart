import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/extensions/validation_message_extension.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/logic/profile_field_access.dart';
import '../../domain/models/profile_field.dart';
import '../view_models/profile_form_state.dart';
import '../view_models/profile_form_view_model.dart';

/// Text fields of the business profile. Onboarding shows the basics;
/// the profile screen passes [extended] for tax id and invoice defaults.
class ProfileDetailsFields extends ConsumerWidget {
  const ProfileDetailsFields({
    required this.form,
    this.extended = false,
    super.key,
  });

  final ProfileFormState form;
  final bool extended;

  static const List<ProfileField> _basic = [
    ProfileField.name,
    ProfileField.phone,
    ProfileField.email,
    ProfileField.address,
  ];
  static const List<ProfileField> _business = [
    ProfileField.website,
    ProfileField.taxId,
  ];
  static const List<ProfileField> _defaults = [
    ProfileField.paymentInstructions,
    ProfileField.defaultNotes,
    ProfileField.defaultTerms,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vm = ref.read(profileFormViewModelProvider.notifier);
    Widget field(ProfileField f) =>
        _ProfileTextField(form: form, field: f, onChanged: vm.updateField);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.md,
      children: [
        ..._basic.map(field),
        if (extended) ...[
          ..._business.map(field),
          const SizedBox(height: AppSpacing.sm),
          SectionHeader(title: context.l10n.sectionInvoiceDefaults),
          ..._defaults.map(field),
        ],
      ],
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  const _ProfileTextField({
    required this.form,
    required this.field,
    required this.onChanged,
  });

  final ProfileFormState form;
  final ProfileField field;
  final void Function(ProfileField field, String value) onChanged;

  static const int _multiLines = 3;

  bool get _multiline => switch (field) {
    ProfileField.address ||
    ProfileField.paymentInstructions ||
    ProfileField.defaultNotes ||
    ProfileField.defaultTerms => true,
    _ => false,
  };

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
    ProfileField.name => (l10n.fieldBusinessName, l10n.fieldBusinessNameHint),
    ProfileField.phone => (l10n.fieldPhone, null),
    ProfileField.email => (l10n.fieldEmail, null),
    ProfileField.website => (l10n.fieldWebsite, null),
    ProfileField.address => (l10n.fieldAddress, null),
    ProfileField.taxId => (l10n.fieldTaxId, null),
    ProfileField.paymentInstructions => (
      l10n.fieldPaymentInstructions,
      l10n.fieldPaymentInstructionsHint,
    ),
    ProfileField.defaultNotes => (l10n.fieldDefaultNotes, null),
    ProfileField.defaultTerms => (l10n.fieldDefaultTerms, null),
  };

  IconData? get _icon => switch (field) {
    ProfileField.name => AppIcons.business,
    ProfileField.phone => AppIcons.phone,
    ProfileField.email => AppIcons.email,
    ProfileField.website => AppIcons.website,
    _ => null,
  };

  TextInputType get _keyboard => switch (field) {
    ProfileField.phone => TextInputType.phone,
    ProfileField.email => TextInputType.emailAddress,
    ProfileField.website => TextInputType.url,
    _ when _multiline => TextInputType.multiline,
    _ => TextInputType.text,
  };

  TextCapitalization get _capitalization => switch (field) {
    ProfileField.name || ProfileField.address => TextCapitalization.words,
    ProfileField.paymentInstructions ||
    ProfileField.defaultNotes ||
    ProfileField.defaultTerms => TextCapitalization.sentences,
    _ => TextCapitalization.none,
  };
}
