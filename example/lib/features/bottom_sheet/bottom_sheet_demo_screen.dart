import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'bottom_sheet_demo.dart';

class BottomSheetDemoScreen extends StatelessWidget {
  const BottomSheetDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.bottomSheet,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const BottomSheetDemo(),
  );
}
