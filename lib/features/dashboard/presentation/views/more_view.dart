import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/l10n_extension.dart';
import '../../../../core/widgets/layout/app_scaffold.dart';
import '../widgets/app_menu_body.dart';

/// More tab: same grouped menu as the side drawer (profile, Pro, links).
class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(title: context.l10n.navMore, body: const AppMenuBody());
  }
}
