import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../directions/direction_editor_preview.dart';
import '../directions/direction_home_preview.dart';
import '../directions/direction_palette.dart';

/// Debug-only comparison of three proposed looks. The real screens stay as they are.
class DesignDirectionsView extends StatefulWidget {
  const DesignDirectionsView({super.key});

  @override
  State<DesignDirectionsView> createState() => _DesignDirectionsViewState();
}

class _DesignDirectionsViewState extends State<DesignDirectionsView> {
  DirectionKind _kind = DirectionKind.ledger;
  bool _editor = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final palette = DirectionPalette.of(_kind, Theme.of(context).brightness);
    return AppScaffold(
      title: l10n.designDirectionsTitle,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.sm,
              AppSpacing.pagePadding,
              AppSpacing.sm,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _KindPicker(
                  kind: _kind,
                  onChanged: (kind) => setState(() => _kind = kind),
                ),
                const SizedBox(height: AppSpacing.sm),
                SegmentedButton<bool>(
                  segments: [
                    ButtonSegment(value: false, label: Text(l10n.previewHome)),
                    ButtonSegment(value: true, label: Text(l10n.previewEditor)),
                  ],
                  selected: {_editor},
                  onSelectionChanged: (value) =>
                      setState(() => _editor = value.first),
                ),
              ],
            ),
          ),
          Expanded(
            child: _editor
                ? DirectionEditorPreview(kind: _kind, palette: palette)
                : DirectionHomePreview(kind: _kind, palette: palette),
          ),
        ],
      ),
    );
  }
}

class _KindPicker extends StatelessWidget {
  const _KindPicker({required this.kind, required this.onChanged});

  final DirectionKind kind;
  final ValueChanged<DirectionKind> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SegmentedButton<DirectionKind>(
      segments: [
        ButtonSegment(
          value: DirectionKind.ledger,
          label: Text(l10n.directionLedger),
        ),
        ButtonSegment(
          value: DirectionKind.current,
          label: Text(l10n.directionCurrent),
        ),
        ButtonSegment(
          value: DirectionKind.atelier,
          label: Text(l10n.directionAtelier),
        ),
      ],
      selected: {kind},
      onSelectionChanged: (value) => onChanged(value.first),
    );
  }
}
