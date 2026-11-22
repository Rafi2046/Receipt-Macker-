import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/ads/ad_providers.dart';
import '../../services/pdf/pdf_template.dart';
import '../../services/purchases/template_choice.dart';
import '../../services/service_providers.dart';
import '../../utils/extensions/l10n_extension.dart';
import 'pro_gate_sheet.dart';

/// Applies a template. For a Pro design on a free account it offers a
/// rewarded ad (use it once) or Pro, and applies it after the ad.
Future<void> choosePdfTemplate(
  BuildContext context,
  WidgetRef ref, {
  required PdfTemplate template,
  required Future<bool> Function(PdfTemplate template) setTemplate,
}) async {
  if (await setTemplate(template) || !context.mounted) return;
  final l10n = context.l10n;
  final earned = await ProGateSheet.show(
    context,
    title: l10n.templateProTitle,
    body: l10n.templateProBody,
    watchAd: ref.read(rewardedAdPresenterProvider).showForReward,
  );
  if (!earned) return;
  await TemplateChoice.unlockWithAd(ref.read(appPreferencesProvider), template);
  await setTemplate(template);
}
