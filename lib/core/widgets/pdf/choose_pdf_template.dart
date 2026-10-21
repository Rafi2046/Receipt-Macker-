import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/route_names.dart';
import '../../services/pdf/pdf_template.dart';

/// Applies a template, or opens the paywall when it is a Pro design.
Future<void> choosePdfTemplate(
  BuildContext context, {
  required PdfTemplate template,
  required Future<bool> Function(PdfTemplate template) setTemplate,
}) async {
  final allowed = await setTemplate(template);
  if (!allowed && context.mounted) {
    await context.pushNamed(RouteNames.paywall);
  }
}
