import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'top_bar_demo.dart';

class TopBarDemoScreen extends StatelessWidget {
  const TopBarDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.topBars,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const TopBarDemo(),
  );
}
