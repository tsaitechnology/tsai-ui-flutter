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
    section: ComponentDemoSection.inputPhone,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const PhoneInputDemo(),
  );
}

class SearchInputDemoScreen extends StatelessWidget {
  const SearchInputDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.inputSearch,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const SearchInputDemo(),
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
    section: ComponentDemoSection.inputPin,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const PinInputDemo(),
  );
}

class TextareaDemoScreen extends StatelessWidget {
  const TextareaDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.textarea,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const TextareaDemo(),
  );
}
