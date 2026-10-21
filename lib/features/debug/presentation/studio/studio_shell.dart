import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/l10n_extension.dart';
import 'studio_demo.dart';
import 'studio_font.dart';
import 'studio_invoice.dart';
import 'studio_palette.dart';
import 'studio_scope.dart';
import 'studio_type.dart';
import 'widgets/studio_clients_view.dart';
import 'widgets/studio_detail_view.dart';
import 'widgets/studio_editor_view.dart';
import 'widgets/studio_home_view.dart';
import 'widgets/studio_invoices_view.dart';
import 'widgets/studio_more_view.dart';
import 'widgets/studio_nav_bar.dart';

/// Full-screen mock of the Current direction. The real app is unchanged.
class StudioShell extends StatefulWidget {
  const StudioShell({super.key});

  @override
  State<StudioShell> createState() => _StudioShellState();
}

class _StudioShellState extends State<StudioShell> {
  int _tab = 0;
  int _month = StudioDemo.months.length - 1;
  StudioFont _font = StudioFont.manrope;
  StudioInvoice? _open;
  bool _editor = false;

  void _close() => setState(() {
    _open = null;
    _editor = false;
  });

  @override
  Widget build(BuildContext context) {
    final palette = StudioPalette.of(Theme.of(context).brightness);
    final l10n = context.l10n;
    final open = _open;
    return StudioScope(
      palette: palette,
      type: StudioType(_font.family),
      font: _font,
      child: Material(
        color: palette.background,
        child: _editor
            ? StudioEditorView(onBack: _close)
            : open != null
            ? StudioDetailView(invoice: open, onBack: _close)
            : _Tabs(
                tab: _tab,
                month: _month,
                font: _font,
                labels: [
                  l10n.navHome,
                  l10n.invoicesTitle,
                  l10n.clientsTitle,
                  l10n.navMore,
                ],
                createLabel: l10n.invoiceNewTitle,
                onTab: (index) => setState(() => _tab = index),
                onMonth: (index) => setState(() => _month = index),
                onFont: (font) => setState(() => _font = font),
                onOpen: (invoice) => setState(() => _open = invoice),
                onCreate: () => setState(() => _editor = true),
              ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tab,
    required this.month,
    required this.font,
    required this.labels,
    required this.createLabel,
    required this.onTab,
    required this.onMonth,
    required this.onFont,
    required this.onOpen,
    required this.onCreate,
  });

  final int tab;
  final int month;
  final StudioFont font;
  final List<String> labels;
  final String createLabel;
  final ValueChanged<int> onTab;
  final ValueChanged<int> onMonth;
  final ValueChanged<StudioFont> onFont;
  final ValueChanged<StudioInvoice> onOpen;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: tab,
              children: [
                StudioHomeView(
                  months: StudioDemo.months,
                  monthIndex: month,
                  onMonth: onMonth,
                  onOpen: onOpen,
                  onSeeAll: () => onTab(1),
                  onNewInvoice: onCreate,
                  onRecordPayment: () => onTab(1),
                  onAddClient: () => onTab(2),
                  onAddItem: () => onTab(3),
                  onSettings: () => onTab(3),
                ),
                StudioInvoicesView(onOpen: onOpen),
                const StudioClientsView(),
                StudioMoreView(font: font, onFont: onFont),
              ],
            ),
          ),
        ),
        StudioNavBar(
          index: tab,
          labels: labels,
          createLabel: createLabel,
          onSelected: onTab,
          onCreate: onCreate,
        ),
      ],
    );
  }
}
