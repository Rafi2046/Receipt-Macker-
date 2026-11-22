import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_icons.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/utils/extensions/l10n_extension.dart';
import '../../core/widgets/display/icon_badge.dart';
import '../../core/widgets/layout/app_card.dart';
import '../router/route_names.dart';
import '../theme/app_colors.dart';

/// What the dock's create button makes: an invoice or an estimate.
abstract final class CreateChoiceSheet {
  static Future<void> show(BuildContext context) async {
    final route = await showModalBottomSheet<String>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: context.appColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.xxl),
        ),
      ),
      builder: (_) => const _Body(),
    );
    if (route == null || !context.mounted) return;
    await context.pushNamed(route);
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        0,
        AppSpacing.pagePadding,
        AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Text(
            l10n.createChooseTitle,
            style: context.textStyles.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          _Choice(
            icon: AppIcons.invoice,
            tone: colors.primary,
            title: l10n.invoiceNewTitle,
            hint: l10n.createInvoiceHint,
            route: RouteNames.invoiceNew,
          ),
          _Choice(
            icon: AppIcons.quote,
            tone: colors.info,
            title: l10n.quoteNewTitle,
            hint: l10n.createEstimateHint,
            route: RouteNames.quoteNew,
          ),
        ],
      ),
    );
  }
}

class _Choice extends StatelessWidget {
  const _Choice({
    required this.icon,
    required this.tone,
    required this.title,
    required this.hint,
    required this.route,
  });

  final IconData icon;
  final Color tone;
  final String title;
  final String hint;
  final String route;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AppCard(
      onTap: () => Navigator.of(context).pop(route),
      child: Row(
        children: [
          IconBadge(icon: icon, color: tone),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  hint,
                  style: context.textStyles.bodySmall?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(AppIcons.chevronRight, color: colors.textSecondary),
        ],
      ),
    );
  }
}
