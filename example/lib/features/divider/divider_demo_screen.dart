import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class DividerDemoScreen extends StatelessWidget {
  const DividerDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.divider,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _DividerDemo(),
  );
}

class _DividerDemo extends StatefulWidget {
  const _DividerDemo();

  @override
  State<_DividerDemo> createState() => _DividerDemoState();
}

class _DividerDemoState extends State<_DividerDemo> {
  var _indent = 0.0;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('divider-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: SizedBox(
          width: 342,
          child: TsaiDivider(indent: _indent, endIndent: _indent),
        ),
        controls: [
          PlaygroundRadioGroup<double>(
            label: 'inset',
            value: _indent,
            options: const [(0, 'Flush'), (16, '16'), (24, '24')],
            onChanged: (value) => setState(() => _indent = value),
          ),
        ],
      ),
    ],
  );
}
