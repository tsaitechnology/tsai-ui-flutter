import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';
import 'chart_demo_data.dart';

class BarChartDemoScreen extends StatelessWidget {
  const BarChartDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.barChart,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _BarChartDemo(),
  );
}

class _BarChartDemo extends StatefulWidget {
  const _BarChartDemo();

  @override
  State<_BarChartDemo> createState() => _BarChartDemoState();
}

class _BarChartDemoState extends State<_BarChartDemo> {
  var _period = TsaiChartPeriod.oneWeek;
  var _status = TsaiChartStatus.data;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('barChart-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiBarChart(
          points: barChartPointsFor(_period),
          period: _period,
          status: _status,
          onPeriodChanged: (value) => setState(() => _period = value),
          onRetry: () => setState(() => _status = TsaiChartStatus.data),
        ),
        controls: [
          PlaygroundSelectControl<TsaiChartStatus>(
            label: 'status',
            value: _status,
            values: TsaiChartStatus.values,
            onChanged: (value) => setState(() => _status = value),
          ),
        ],
      ),
    ],
  );
}
