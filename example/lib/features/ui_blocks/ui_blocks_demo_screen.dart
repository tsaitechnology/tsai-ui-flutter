import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'ui_blocks_demo.dart';

class UIBlocksDemoScreen extends StatelessWidget {
  const UIBlocksDemoScreen({
    required this.section,
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ComponentDemoSection section;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: section,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: UIBlocksDemo(section: section),
  );
}
