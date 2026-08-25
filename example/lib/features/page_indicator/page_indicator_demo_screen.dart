import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class PageIndicatorDemoScreen extends StatelessWidget {
  const PageIndicatorDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.pageIndicator,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _PageIndicatorDemo(),
  );
}

class _PageIndicatorDemo extends StatefulWidget {
  const _PageIndicatorDemo();

  @override
  State<_PageIndicatorDemo> createState() => _PageIndicatorDemoState();
}

class _PageIndicatorDemoState extends State<_PageIndicatorDemo> {
  var _count = 5;
  var _index = 0;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('pageIndicator-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiPageIndicator(count: _count, index: _index),
        controls: [
          PlaygroundRadioGroup<int>(
            label: 'count',
            value: _count,
            options: const [(3, '3'), (4, '4'), (5, '5')],
            onChanged: (value) => setState(() {
              _count = value;
              if (_index >= _count) {
                _index = _count - 1;
              }
            }),
          ),
          PlaygroundRadioGroup<int>(
            label: 'index',
            value: _index,
            options: [for (var i = 0; i < _count; i++) (i, '${i + 1}')],
            onChanged: (value) => setState(() => _index = value),
          ),
        ],
      ),
    ],
  );
}
