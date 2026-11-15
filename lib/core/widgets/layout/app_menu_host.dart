import 'package:flutter/widgets.dart';

/// Lets tab roots open the shell side menu without importing the shell.
class AppMenuHost extends InheritedWidget {
  const AppMenuHost({required this.openMenu, required super.child, super.key});

  final VoidCallback openMenu;

  static VoidCallback? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppMenuHost>()?.openMenu;
  }

  @override
  bool updateShouldNotify(AppMenuHost oldWidget) =>
      openMenu != oldWidget.openMenu;
}
