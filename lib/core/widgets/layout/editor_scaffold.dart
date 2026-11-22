import 'package:flutter/material.dart';

import '../../constants/app_icons.dart';
import '../../constants/app_spacing.dart';
import '../../utils/extensions/l10n_extension.dart';
import '../buttons/app_button.dart';
import '../buttons/app_icon_button.dart';
import '../feedback/confirm_dialog.dart';
import 'app_scaffold.dart';
import 'bottom_action_bar.dart';

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
    this.secondaryLabel,
    this.onSecondary,
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

  /// A quieter button beside Save (e.g. Preview); shown when both are set.
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

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
            : _SaveBar(
                isSaving: isSaving,
                onSave: save,
                secondaryLabel: secondaryLabel,
                onSecondary: onSecondary,
              ),
      ),
    );
  }
}

/// Save (and an optional quieter button) on a [BottomActionBar].
class _SaveBar extends StatelessWidget {
  const _SaveBar({
    required this.isSaving,
    required this.onSave,
    this.secondaryLabel,
    this.onSecondary,
  });

  final bool isSaving;
  final VoidCallback onSave;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  static const int _secondaryFlex = 2;
  static const int _saveFlex = 3;

  @override
  Widget build(BuildContext context) {
    final save = AppButton(
      label: context.l10n.save,
      expand: true,
      isLoading: isSaving,
      onPressed: onSave,
    );
    final label = secondaryLabel;
    final secondary = onSecondary;
    final button = label == null || secondary == null
        ? save
        : Row(
            spacing: AppSpacing.md,
            children: [
              Expanded(
                flex: _secondaryFlex,
                child: AppButton(
                  label: label,
                  variant: AppButtonVariant.secondary,
                  expand: true,
                  onPressed: isSaving ? null : secondary,
                ),
              ),
              Expanded(flex: _saveFlex, child: save),
            ],
          );
    return BottomActionBar(child: button);
  }
}
