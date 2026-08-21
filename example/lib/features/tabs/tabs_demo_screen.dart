import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'tabs_demo.dart';

class TabsDocumentDemoScreen extends StatelessWidget {
  const TabsDocumentDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.tabsDocument,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const TabsCatalogDemo(),
  );
}
