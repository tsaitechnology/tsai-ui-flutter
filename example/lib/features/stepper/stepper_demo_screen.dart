import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class StepperDemoScreen extends StatelessWidget {
  const StepperDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.stepper,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _StepperDemo(),
  );
}

class _StepperDemo extends StatefulWidget {
  const _StepperDemo();

  @override
  State<_StepperDemo> createState() => _StepperDemoState();
}

class _StepperDemoState extends State<_StepperDemo> {
  var _value = 1;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('stepper-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiStepper(
          value: _value,
          onChanged: (value) => setState(() => _value = value),
        ),
        controls: [PlaygroundOutput(label: 'value', value: '$_value')],
      ),
    ],
  );
}
