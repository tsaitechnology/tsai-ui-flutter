import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'link_demo.dart';

class LinkDemoScreen extends StatelessWidget {
  const LinkDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.links,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const LinkDemo(),
  );
}
