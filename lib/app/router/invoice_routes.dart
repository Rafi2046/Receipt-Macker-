import 'package:go_router/go_router.dart';

import '../../features/invoices/presentation/views/invoice_detail_view.dart';
import '../../features/invoices/presentation/views/invoice_editor_view.dart';
import '../../features/invoices/presentation/views/invoice_list_view.dart';
import 'route_names.dart';

/// `/invoices` (list), `/invoices/new?copyOf=` (editor, optionally a copy),
/// `/invoices/:id` (detail) and `/invoices/:id/edit` (editor).
/// "new" is listed before ":id" so it never matches as an id.
final GoRoute invoiceRoutes = GoRoute(
  name: RouteNames.invoices,
  path: RouteNames.invoicesPath,
  builder: (_, _) => const InvoiceListView(),
  routes: [
    GoRoute(
      name: RouteNames.invoiceNew,
      path: RouteNames.invoiceNewPath,
      builder: (_, state) => InvoiceEditorView(
        copyOf: state.uri.queryParameters[RouteNames.copyOfParam],
      ),
    ),
    GoRoute(
      name: RouteNames.invoiceDetail,
      path: RouteNames.invoiceDetailPath,
      builder: (_, state) => InvoiceDetailView(
        invoiceId: state.pathParameters[RouteNames.idParam] ?? '',
      ),
      routes: [
        GoRoute(
          name: RouteNames.invoiceEdit,
          path: RouteNames.invoiceEditPath,
          builder: (_, state) => InvoiceEditorView(
            invoiceId: state.pathParameters[RouteNames.idParam],
          ),
        ),
      ],
    ),
  ],
);
