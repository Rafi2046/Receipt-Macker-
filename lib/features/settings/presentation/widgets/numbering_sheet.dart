import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/money_input_parser.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../view_models/app_settings_view_model.dart';

/// Edits the invoice prefix and next number. Closes after a good save; a
/// number at or below the highest used one shows an error in place.
abstract final class NumberingSheet {
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
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
      builder: (_) => const _Body(),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  late final TextEditingController _prefix;
  late final TextEditingController _next;
  bool _invalid = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(appSettingsViewModelProvider);
    _prefix = TextEditingController(text: state.invoicePrefix);
    _next = TextEditingController(text: '${state.nextInvoiceSequence}');
  }

  @override
  void dispose() {
    _prefix.dispose();
    _next.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final vm = ref.read(appSettingsViewModelProvider.notifier);
    final ok = await vm.updateNumbering(
      prefix: _prefix.text,
      // Bangla digits are fine to type here.
      nextSequence:
          int.tryParse(MoneyInputParser.normalize(_next.text).trim()) ?? 0,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
      return;
    }
    vm.clearFeedback();
    setState(() => _invalid = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.appColors;
    final state = ref.watch(appSettingsViewModelProvider);
    final format = AppFormatters(Localizations.localeOf(context).languageCode);
    final help = l10n.settingsNumberingHelp(
      format.integer(state.highestInvoiceSequence),
    );
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.pagePadding,
        0,
        AppSpacing.pagePadding,
        AppSpacing.xxl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.md,
        children: [
          Text(
            l10n.settingsNumberingTitle,
            style: context.textStyles.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          AppTextField(
            label: l10n.settingsPrefix,
            controller: _prefix,
            textCapitalization: TextCapitalization.characters,
          ),
          AppTextField(
            label: l10n.settingsNextNumber,
            controller: _next,
            keyboardType: TextInputType.number,
            errorText: _invalid ? l10n.settingsNumberingInvalid : null,
          ),
          Text(
            help,
            style: context.textStyles.bodySmall?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          AppButton(
            label: l10n.settingsSaveNumbering,
            isLoading: state.isSaving,
            expand: true,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
