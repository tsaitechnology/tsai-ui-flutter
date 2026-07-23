import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'selection_controls_demo.dart';

class CheckboxDemoScreen extends StatelessWidget {
  const CheckboxDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.checkbox,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const CheckboxDemo(),
  );
}

class RadioDemoScreen extends StatelessWidget {
  const RadioDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.radio,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const RadioDemo(),
  );
}

class SwitchDemoScreen extends StatelessWidget {
  const SwitchDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.switchControl,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const SwitchDemo(),
  );
}
