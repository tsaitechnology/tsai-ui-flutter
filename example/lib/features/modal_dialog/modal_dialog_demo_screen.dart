import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'modal_dialog_demo.dart';

class ModalDialogDemoScreen extends StatelessWidget {
  const ModalDialogDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.modalDialog,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const ModalDialogDemo(),
  );
}
