import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'typography_demo.dart';

class TypographyDemoScreen extends StatelessWidget {
  const TypographyDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.typography,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const TypographyDemo(),
  );
}
