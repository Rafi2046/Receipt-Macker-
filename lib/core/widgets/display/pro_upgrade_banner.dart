import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_radius.dart';
import '../../constants/app_spacing.dart';
import '../../services/purchases/purchase_providers.dart';
import '../../utils/extensions/l10n_extension.dart';

/// Pro upgrade strip (menu, settings); shows the active state for Pro. No countdown — CLAUDE §9.1.
class ProUpgradeBanner extends ConsumerWidget {
  const ProUpgradeBanner({this.onNavigate, super.key});

  final VoidCallback? onNavigate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final pro = ref.watch(proStatusProvider);
    final colors = context.appColors;
    return Material(
      color: colors.primary,
      borderRadius: AppRadius.card,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          final router = GoRouter.of(context);
          final route = pro ? RouteNames.proWelcome : RouteNames.paywall;
          onNavigate?.call();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            router.pushNamed(route);
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Icon(AppIcons.proBadge, color: colors.onPrimary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.proMoreTitle,
                      style: context.textStyles.titleSmall?.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      pro ? l10n.proMoreActive : l10n.proMoreBody,
                      style: context.textStyles.bodySmall?.copyWith(
                        color: colors.onPrimary.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              if (!pro)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: AppRadius.chip,
                  ),
                  child: Text(
                    l10n.proGet,
                    style: context.textStyles.labelLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
