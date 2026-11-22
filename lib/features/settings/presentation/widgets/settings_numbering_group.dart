import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/layout/editor_row.dart';
import '../view_models/app_settings_view_model.dart';
import 'numbering_sheet.dart';
import 'settings_group.dart';

/// The invoice number row: shows the next number, opens the editor sheet.
class SettingsNumberingGroup extends ConsumerWidget {
  const SettingsNumberingGroup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(appSettingsViewModelProvider);
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    return SettingsGroup(
      title: l10n.settingsNumbering,
      children: [
        EditorRow(
          icon: AppIcons.setNumbering,
          iconSize: AppSizes.iconRow,
          title: l10n.settingsNumberingTitle,
          subtitle: l10n.settingsNumberingNext(
            format.localizeDigits(state.nextInvoiceNumber),
          ),
          onTap: () => NumberingSheet.show(context),
        ),
      ],
    );
  }
}
