import 'package:flutter/material.dart';

import '../../demo/component_demo_window.dart';
import 'input_demo.dart';

class InputDemoScreen extends StatelessWidget {
  const InputDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.input,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const InputDemo(),
  );
}

class PhoneInputDemoScreen extends StatelessWidget {
  const PhoneInputDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.inputPhone,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const PhoneInputDemo(),
  );
}

class OtpInputDemoScreen extends StatelessWidget {
  const OtpInputDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.inputOtp,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const OtpInputDemo(),
  );
}

class PinInputDemoScreen extends StatelessWidget {
  const PinInputDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    title: 'Tsai UI',
    section: ComponentDemoSection.inputPin,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const PinInputDemo(),
  );
}
