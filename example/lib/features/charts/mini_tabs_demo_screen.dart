import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class MiniTabsDemoScreen extends StatelessWidget {
  const MiniTabsDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.miniTabs,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _MiniTabsDemo(),
  );
}

class _MiniTabsDemo extends StatefulWidget {
  const _MiniTabsDemo();

  @override
  State<_MiniTabsDemo> createState() => _MiniTabsDemoState();
}

class _MiniTabsDemoState extends State<_MiniTabsDemo> {
  var _index = 2;
  var _count = 5;

  static const _labels = ['1D', '1W', '1M', '1Y', 'All'];

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('miniTabs-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiMiniTabs(
          labels: _labels.take(_count).toList(),
          selectedIndex: _index.clamp(0, _count - 1),
          onChanged: (value) => setState(() => _index = value),
        ),
        controls: [
          PlaygroundSelectControl<int>(
            label: 'segments',
            value: _count,
            values: const [3, 4, 5],
            onChanged: (value) => setState(() {
              _count = value;
              _index = _index.clamp(0, _count - 1);
            }),
          ),
        ],
      ),
    ],
  );
}
