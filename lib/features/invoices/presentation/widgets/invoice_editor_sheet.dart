import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/soft_input_theme.dart';
import '../view_models/invoice_editor_state.dart';
import '../view_models/invoice_editor_view_model.dart';

/// Builds a sheet's fields from the live draft.
typedef InvoiceSheetBuilder = Widget Function(
  InvoiceEditorState form,
  InvoiceEditorViewModel vm,
);

/// A bottom sheet that edits part of the invoice draft in place: a title,
/// Done, and the fields from [builder], rebuilt as the draft changes.
class InvoiceEditorSheet extends ConsumerWidget {
  const InvoiceEditorSheet({
    required this.provider,
    required this.title,
    required this.builder,
    super.key,
  });

  final InvoiceEditorViewModelProvider provider;
  final String title;
  final InvoiceSheetBuilder builder;

  static Future<void> show(
    BuildContext context, {
    required InvoiceEditorViewModelProvider provider,
    required String title,
    required InvoiceSheetBuilder builder,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: context.appColors.background,
    builder: (_) =>
        InvoiceEditorSheet(provider: provider, title: title, builder: builder),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(provider).value;
    if (form == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
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
            Row(
              children: [
                Expanded(
                  child: Text(title, style: context.textStyles.titleLarge),
                ),
                AppButton(
                  label: context.l10n.done,
                  variant: AppButtonVariant.text,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SoftInputTheme(child: builder(form, ref.read(provider.notifier))),
          ],
        ),
      ),
    );
  }
}
