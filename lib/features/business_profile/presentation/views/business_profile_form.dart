import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/more_fields_toggle.dart';
import '../../../../core/widgets/inputs/soft_input_theme.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/section_header.dart';
import '../../domain/logic/profile_field_access.dart';
import '../../domain/models/profile_field.dart';
import '../view_models/profile_form_state.dart';
import '../widgets/profile_details_fields.dart';
import '../widgets/profile_logo_hero.dart';
import '../widgets/profile_signature_card.dart';

/// The business profile page: the logo, name / phone / email, then
/// website, address and tax ID behind "Show more fields", then the invoice
/// defaults and signature.
class BusinessProfileForm extends StatefulWidget {
  const BusinessProfileForm({required this.form, super.key});

  final ProfileFormState form;

  @override
  State<BusinessProfileForm> createState() => _BusinessProfileFormState();
}

class _BusinessProfileFormState extends State<BusinessProfileForm> {
  /// Starts open when any of the extra fields is filled in.
  late bool _showMore = _extra.any(
    (f) => widget.form.draft.valueOf(f).trim().isNotEmpty,
  );

  static const List<ProfileField> _extra = [
    ProfileField.website,
    ProfileField.address,
    ProfileField.taxId,
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final form = widget.form;
    // A problem in a folded field opens it, so the error is seen.
    final expanded = _showMore || _extra.any((f) => form.errorFor(f) != null);
    Widget card(List<ProfileField> fields) => AppCard(
      child: ProfileDetailsFields(
        form: form,
        showIcons: false,
        optionalHint: true,
        labelsAbove: true,
        fields: fields,
      ),
    );
    const gap = SizedBox(height: AppSpacing.md);
    return SoftInputTheme(
      style: SoftInputStyle.boxed,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          Center(child: ProfileLogoHero(form: form)),
          const SizedBox(height: AppSpacing.lg),
          card(const [
            ProfileField.name,
            ProfileField.phone,
            ProfileField.email,
          ]),
          if (expanded) ...[
            gap,
            card(const [ProfileField.website]),
            gap,
            card(const [ProfileField.address]),
            gap,
            card(const [ProfileField.taxId]),
          ],
          gap,
          MoreFieldsToggle(
            expanded: expanded,
            onPressed: () => setState(() => _showMore = !expanded),
          ),
          const SizedBox(height: AppSpacing.sectionGap),
          SectionHeader(title: l10n.sectionInvoiceDefaults),
          const SizedBox(height: AppSpacing.sm),
          card(const [
            ProfileField.paymentInstructions,
            ProfileField.defaultNotes,
            ProfileField.defaultTerms,
          ]),
          gap,
          ProfileSignatureCard(form: form),
        ],
      ),
    );
  }
}
