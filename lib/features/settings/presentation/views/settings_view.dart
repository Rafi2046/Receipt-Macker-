import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_bar_variant.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/display/pro_upgrade_banner.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../view_models/app_settings_view_model.dart';
import '../widgets/settings_appearance_group.dart';
import '../widgets/settings_business_group.dart';
import '../widgets/settings_business_header.dart';
import '../widgets/settings_debug_group.dart';
import '../widgets/settings_defaults_group.dart';
import '../widgets/settings_links_group.dart';
import '../widgets/settings_numbering_group.dart';

/// The Settings tab: the business, Pro, business records, preferences and
/// help, as grouped cards of rows that open sheets or pages.
class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(appSettingsViewModelProvider.notifier).loadNumbering();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    ref.listen(appSettingsViewModelProvider.select((s) => s.numberingSaved), (
      _,
      saved,
    ) {
      if (!saved) return;
      AppSnackbar.show(
        context,
        l10n.settingsNumberingSaved,
        tone: AppSnackbarTone.success,
      );
      ref.read(appSettingsViewModelProvider.notifier).clearFeedback();
    });

    return AppScaffold(
      title: l10n.settingsTitle,
      variant: AppBarVariant.pushed,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pagePadding,
          AppSpacing.sm,
          AppSpacing.pagePadding,
          AppSizes.fabClearance,
        ),
        children: [
          const SettingsBusinessHeader(),
          const SizedBox(height: AppSpacing.lg),
          const ProUpgradeBanner(),
          const SizedBox(height: AppSpacing.sectionGap),
          const SettingsBusinessGroup(),
          const SizedBox(height: AppSpacing.sectionGap),
          const SettingsAppearanceGroup(),
          const SizedBox(height: AppSpacing.sectionGap),
          const SettingsDefaultsGroup(),
          const SizedBox(height: AppSpacing.sectionGap),
          const SettingsNumberingGroup(),
          const SizedBox(height: AppSpacing.sectionGap),
          const SettingsLinksGroup(),
          if (kDebugMode) ...[
            const SizedBox(height: AppSpacing.sectionGap),
            const SettingsDebugGroup(),
          ],
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppConstants.publisher,
            textAlign: TextAlign.center,
            style: context.textStyles.labelSmall?.copyWith(
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
