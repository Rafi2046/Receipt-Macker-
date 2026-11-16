import 'package:go_router/go_router.dart';

import '../../features/quotes/presentation/views/quote_editor_view.dart';
import '../../features/quotes/presentation/views/quote_list_view.dart';
import '../../features/quotes/presentation/views/quote_pdf_view.dart';
import 'route_names.dart';

final GoRoute quoteRoutes = GoRoute(
  name: RouteNames.quotes,
  path: RouteNames.quotesPath,
  builder: (_, _) => const QuoteListView(),
  routes: [
    GoRoute(
      name: RouteNames.quoteNew,
      path: RouteNames.quoteNewPath,
      builder: (_, _) => const QuoteEditorView(),
    ),
    GoRoute(
      name: RouteNames.quoteEdit,
      path: RouteNames.quoteEditPath,
      builder: (_, state) =>
          QuoteEditorView(quoteId: state.pathParameters[RouteNames.idParam]),
      routes: [
        GoRoute(
          name: RouteNames.quotePdf,
          path: RouteNames.quotePdfPath,
          builder: (_, state) => QuotePdfView(
            quoteId: state.pathParameters[RouteNames.idParam] ?? '',
          ),
        ),
      ],
    ),
  ],
);
