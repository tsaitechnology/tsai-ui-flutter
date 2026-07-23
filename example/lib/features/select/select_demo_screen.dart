import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'select_demo.dart';

class SelectDemoScreen extends StatelessWidget {
  const SelectDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.select,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const SelectDemo(),
  );
}
