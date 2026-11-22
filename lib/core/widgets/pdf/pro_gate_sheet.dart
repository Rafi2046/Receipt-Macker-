import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../../app/theme/app_colors.dart';
import '../../constants/app_icons.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../buttons/app_button.dart';

/// Shown when a free user taps a Pro choice (a color, a design): watch a
/// rewarded ad to use it once, or go Pro. Returns true only when the ad's reward was earned.
abstract final class ProGateSheet {
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String body,
    required Future<bool> Function() watchAd,
  }) async {
    final result = await showModalBottomSheet<_Outcome>(
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
      builder: (_) => _Body(title: title, body: body, watchAd: watchAd),
    );
    if (result == _Outcome.goPro && context.mounted) {
      await context.pushNamed(RouteNames.paywall);
    }
    return result == _Outcome.unlocked;
  }
}

enum _Outcome { unlocked, goPro }

class _Body extends StatefulWidget {
  const _Body({required this.title, required this.body, required this.watchAd});

  final String title;
  final String body;
  final Future<bool> Function() watchAd;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _loading = false;
  bool _failed = false;

  Future<void> _watch() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    final earned = await widget.watchAd();
    if (!mounted) return;
    if (earned) {
      Navigator.of(context).pop(_Outcome.unlocked);
      return;
    }
    setState(() {
      _loading = false;
      _failed = true;
    });
  }

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
        spacing: AppSpacing.md,
        children: [
          Icon(AppIcons.proBadge, size: AppSizes.iconXl, color: colors.warning),
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: context.textStyles.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            widget.body,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (_failed)
            Text(
              l10n.colorAdUnavailable,
              textAlign: TextAlign.center,
              style: context.textStyles.bodySmall?.copyWith(
                color: colors.danger,
              ),
            ),
          const SizedBox(height: AppSpacing.xs),
          AppButton(
            label: l10n.colorWatchAd,
            icon: AppIcons.watchAd,
            variant: AppButtonVariant.secondary,
            isLoading: _loading,
            expand: true,
            onPressed: _watch,
          ),
          AppButton(
            label: l10n.templateUnlockAllCta,
            icon: AppIcons.proBadge,
            expand: true,
            onPressed: _loading
                ? null
                : () => Navigator.of(context).pop(_Outcome.goPro),
          ),
        ],
      ),
    );
  }
}
