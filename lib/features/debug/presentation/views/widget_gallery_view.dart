import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../view_models/widget_gallery_view_model.dart';
import '../widgets/gallery_buttons_section.dart';
import '../widgets/gallery_display_section.dart';
import '../widgets/gallery_feedback_section.dart';
import '../widgets/gallery_inputs_section.dart';
import '../widgets/gallery_layout_section.dart';
import '../widgets/preview_section.dart';

/// Debug screen showing every shared widget in its main states (M1 review).
class WidgetGalleryView extends ConsumerWidget {
  const WidgetGalleryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(widgetGalleryViewModelProvider);
    final vm = ref.read(widgetGalleryViewModelProvider.notifier);
    return AppScaffold(
      title: l10n.galleryTitle,
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pagePadding),
        children: [
          PreviewSection(
            title: l10n.galleryButtons,
            child: GalleryButtonsSection(
              isSaving: state.isSaving,
              onToggleSaving: vm.toggleSaving,
            ),
          ),
          PreviewSection(
            title: l10n.galleryInputs,
            child: GalleryInputsSection(
              state: state,
              currencies: WidgetGalleryViewModel.currencies,
              onNameChanged: vm.setClientName,
              onCurrencyChanged: vm.setCurrency,
              onAmountChanged: vm.setAmount,
              onDueDateChanged: vm.setDueDate,
            ),
          ),
          PreviewSection(
            title: l10n.galleryLayout,
            child: const GalleryLayoutSection(),
          ),
          PreviewSection(
            title: l10n.galleryFeedback,
            child: const GalleryFeedbackSection(),
          ),
          PreviewSection(
            title: l10n.galleryDisplay,
            child: const GalleryDisplaySection(),
          ),
        ],
      ),
    );
  }
}
