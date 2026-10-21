import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';

/// How QuickBill handles data. Shown in the app; there is no hosted page yet.
class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.privacyTitle,
      padded: true,
      body: SingleChildScrollView(child: Text(context.l10n.privacyBody)),
    );
  }
}
