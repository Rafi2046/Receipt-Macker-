/// Which premium AppBar layout [AppTopBar] / [AppScaffold] should use.
enum AppBarVariant {
  /// Greeting + business name + trailing actions (Home tab).
  home,

  /// Large left title on a tab root (Invoices, Quotes).
  root,

  /// Title (or back) with an embedded search field (Clients, Items).
  search,

  /// Round back + left title on a pushed screen.
  pushed,

  /// Same chrome as [pushed]; editors pass delete via [actions].
  editor,
}
