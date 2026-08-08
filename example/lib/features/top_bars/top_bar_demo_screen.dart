import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'top_bar_demo.dart';

class HomeTopBarDemoScreen extends StatelessWidget {
  const HomeTopBarDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.homeTopBar,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const HomeTopBarDemo(),
  );
}

class PageTopBarDemoScreen extends StatelessWidget {
  const PageTopBarDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.pageTopBar,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const PageTopBarDemo(),
  );
}

class PageWithTopBarDemoScreen extends StatelessWidget {
  const PageWithTopBarDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.pageWithTopBar,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const PageWithTopBarDemo(),
  );
}

class PageWithSearchTopBarDemoScreen extends StatelessWidget {
  const PageWithSearchTopBarDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.pageWithSearchTopBar,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const PageWithSearchTopBarDemo(),
  );
}
