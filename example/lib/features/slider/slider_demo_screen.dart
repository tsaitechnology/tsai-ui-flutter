import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class SliderDemoScreen extends StatelessWidget {
  const SliderDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.slider,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _SliderDemo(),
  );
}

class _SliderDemo extends StatefulWidget {
  const _SliderDemo();

  @override
  State<_SliderDemo> createState() => _SliderDemoState();
}

class _SliderDemoState extends State<_SliderDemo> {
  var _value = 0.25;
  var _enabled = true;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('slider-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: SizedBox(
          width: 342,
          child: TsaiSlider(
            value: _value,
            onChanged: _enabled
                ? (value) => setState(() => _value = value)
                : null,
          ),
        ),
        controls: [
          PlaygroundToggleControl(
            label: 'enabled',
            value: _enabled,
            onChanged: (value) => setState(() => _enabled = value),
          ),
          PlaygroundOutput(label: 'value', value: _value.toStringAsFixed(2)),
        ],
      ),
    ],
  );
}
