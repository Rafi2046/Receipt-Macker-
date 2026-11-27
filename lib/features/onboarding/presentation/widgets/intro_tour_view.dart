import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';

/// Full-bleed marketing slides shown once before language / business setup.
class IntroTourView extends StatefulWidget {
  const IntroTourView({required this.onFinished, super.key});

  final VoidCallback onFinished;

  @override
  State<IntroTourView> createState() => _IntroTourViewState();
}

class _IntroTourViewState extends State<IntroTourView> {
  final _controller = PageController();
  var _page = 0;

  static const _pageCount = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_page >= _pageCount - 1) {
      widget.onFinished();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pages = [
      _TourPageData(
        image: AppImages.onboardingWelcome,
        title: l10n.onboardingTourWelcomeTitle,
        body: l10n.onboardingTourWelcomeBody,
        coral: true,
      ),
      _TourPageData(
        image: AppImages.onboardingOffline,
        title: l10n.onboardingTourOfflineTitle,
        body: l10n.onboardingTourOfflineBody,
        coral: true,
        imageInCard: true,
      ),
      _TourPageData(
        image: AppImages.onboardingTemplates,
        title: l10n.onboardingTourTemplatesTitle,
        body: l10n.onboardingTourTemplatesBody,
        coral: false,
      ),
    ];
    return ColoredBox(
      color: _page < 2
          ? context.appColors.primary
          : context.appColors.background,
      child: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pagePadding,
                  AppSpacing.sm,
                  AppSpacing.pagePadding,
                  0,
                ),
                child: _SkipChip(
                  onCoral: _page < 2,
                  onPressed: widget.onFinished,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _TourPage(data: pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.pagePadding,
                AppSpacing.md,
                AppSpacing.pagePadding,
                AppSpacing.lg,
              ),
              child: Column(
                children: [
                  _Dots(count: _pageCount, index: _page),
                  const SizedBox(height: AppSpacing.lg),
                  if (_page == _pageCount - 1)
                    AppButton(
                      label: l10n.onboardingTourGetStarted,
                      expand: true,
                      onPressed: _goNext,
                    )
                  else
                    _OnCoralButton(
                      label: l10n.onboardingTourNext,
                      onPressed: _goNext,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnCoralButton extends StatelessWidget {
  const _OnCoralButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.onPrimary,
          foregroundColor: colors.primary,
        ),
        child: Text(label),
      ),
    );
  }
}

class _TourPageData {
  const _TourPageData({
    required this.image,
    required this.title,
    required this.body,
    required this.coral,
    this.imageInCard = false,
  });

  final String image;
  final String title;
  final String body;
  final bool coral;
  final bool imageInCard;
}

class _TourPage extends StatelessWidget {
  const _TourPage({required this.data});

  final _TourPageData data;

  @override
  Widget build(BuildContext context) {
    final onCoral = data.coral;
    final titleColor = onCoral
        ? context.appColors.onPrimary
        : context.appColors.textPrimary;
    final bodyColor = onCoral
        ? context.appColors.onPrimary.withValues(alpha: 0.88)
        : context.appColors.textSecondary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppSpacing.md),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: context.textStyles.headlineSmall?.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            data.body,
            textAlign: TextAlign.center,
            style: context.textStyles.bodyMedium?.copyWith(color: bodyColor),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: data.imageInCard
                ? _ImageCard(path: data.image)
                : _HeroImage(path: data.image),
          ),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.xxl),
      child: Image.asset(path, fit: BoxFit.cover, width: double.infinity),
    );
  }
}

class _ImageCard extends StatelessWidget {
  const _ImageCard({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.xxl),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadowOf(0.12),
            blurRadius: AppSpacing.xxl,
            offset: const Offset(0, AppSpacing.md),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.xxl),
        child: Image.asset(path, fit: BoxFit.cover, width: double.infinity),
      ),
    );
  }
}

class _SkipChip extends StatelessWidget {
  const _SkipChip({required this.onCoral, required this.onPressed});

  final bool onCoral;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fg = onCoral ? colors.onPrimary : colors.primary;
    final bg = onCoral
        ? colors.onPrimary.withValues(alpha: 0.18)
        : colors.primary.withValues(alpha: 0.12);
    return Material(
      color: bg,
      borderRadius: AppRadius.chip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.chip,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Text(
            context.l10n.onboardingTourSkip,
            style: context.textStyles.labelLarge?.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final active = index < 2 ? colors.onPrimary : colors.primary;
    final idle = index < 2
        ? colors.onPrimary.withValues(alpha: 0.35)
        : colors.border;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.sm),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: i == index ? AppSpacing.xl : AppSpacing.sm,
            height: AppSpacing.sm,
            decoration: BoxDecoration(
              color: i == index ? active : idle,
              borderRadius: AppRadius.chip,
            ),
          ),
        ],
      ],
    );
  }
}
