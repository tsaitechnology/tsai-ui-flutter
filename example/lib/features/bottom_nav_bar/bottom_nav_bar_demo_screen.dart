import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'bottom_nav_bar_demo.dart';

class BottomNavBarDemoScreen extends StatelessWidget {
  const BottomNavBarDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.bottomNavBar,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const BottomNavBarDemo(),
  );
}
