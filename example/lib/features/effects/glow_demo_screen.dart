import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'glow_demo.dart';

class GlowDemoScreen extends StatelessWidget {
  const GlowDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.glow,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const GlowDemo(),
  );
}
