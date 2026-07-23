import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'button_demo.dart';

class ButtonDemoScreen extends StatelessWidget {
  const ButtonDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.buttons,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const ButtonDemo(),
  );
}
