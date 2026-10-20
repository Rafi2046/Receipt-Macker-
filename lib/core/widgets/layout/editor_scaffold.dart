import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../buttons/app_button.dart';
import '../buttons/app_icon_button.dart';
import '../feedback/confirm_dialog.dart';
import 'app_scaffold.dart';

/// Frame for form screens: a Save button at the bottom, an optional Delete
/// action, and a "Discard changes?" check when leaving with unsaved edits.
/// Close the screen with `Navigator.pop` after saving or deleting; that
/// skips the check.
class EditorScaffold extends StatelessWidget {
  const EditorScaffold({
    required this.title,
    required this.body,
    this.hasUnsavedChanges = false,
    this.isSaving = false,
    this.onSave,
    this.onDelete,
    super.key,
  });

  final String title;
  final Widget body;
  final bool hasUnsavedChanges;

  /// Shows a spinner on Save and disables Delete.
  final bool isSaving;

  /// Null hides the Save button (e.g. while loading).
  final VoidCallback? onSave;

  /// Null hides the Delete action.
  final VoidCallback? onDelete;

  Future<void> _confirmLeave(BuildContext context) async {
    final l10n = context.l10n;
    final discard = await ConfirmDialog.show(
      context,
      title: l10n.discardChangesTitle,
      message: l10n.discardChangesMessage,
      confirmLabel: l10n.discard,
      destructive: true,
    );
    if (discard && context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final delete = onDelete;
    final save = onSave;
    return PopScope(
      canPop: !hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmLeave(context);
      },
      child: AppScaffold(
        title: title,
        actions: [
          if (delete != null)
            AppIconButton(
              icon: AppIcons.delete,
              semanticLabel: context.l10n.delete,
              onPressed: isSaving ? null : delete,
            ),
        ],
        body: body,
        bottomBarAboveKeyboard: true,
        bottomBar: save == null
            ? null
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: AppButton(
                    label: context.l10n.save,
                    expand: true,
                    isLoading: isSaving,
                    onPressed: save,
                  ),
                ),
              ),
      ),
    );
  }
}
