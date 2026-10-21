import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';

/// Subscription terms. Shown in the app; there is no hosted page yet.
class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.termsTitle,
      padded: true,
      body: SingleChildScrollView(child: Text(context.l10n.termsBody)),
    );
  }
}
