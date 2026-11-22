import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/services/ads/consent_service.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import 'settings_group.dart';

/// Help, the legal pages and ad consent (when the law requires it).
class SettingsLinksGroup extends ConsumerWidget {
  const SettingsLinksGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final consent = ref.watch(privacyOptionsRequiredProvider).value ?? false;
    return SettingsGroup(
      title: l10n.legalSectionTitle,
      children: [
        EditorRow(
          icon: AppIcons.supportHero,
          iconSize: AppSizes.iconRow,
          title: l10n.supportTitle,
          onTap: () => context.pushNamed(RouteNames.support),
        ),
        EditorRow(
          icon: AppIcons.setPrivacy,
          iconSize: AppSizes.iconRow,
          title: l10n.settingsPrivacyPolicy,
          onTap: () => context.pushNamed(RouteNames.privacy),
        ),
        EditorRow(
          icon: AppIcons.setTerms,
          iconSize: AppSizes.iconRow,
          title: l10n.settingsTermsOfService,
          onTap: () => context.pushNamed(RouteNames.terms),
        ),
        if (consent)
          EditorRow(
            icon: AppIcons.setConsent,
            iconSize: AppSizes.iconRow,
            title: l10n.privacyConsentTitle,
            subtitle: l10n.privacyConsentSubtitle,
            onTap: () async {
              await ref.read(consentServiceProvider).showPrivacyOptionsForm();
              ref.invalidate(privacyOptionsRequiredProvider);
            },
          ),
      ],
    );
  }
}
