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
  var _source = TsaiChartStatus.data;
  var _showTabs = true;

  List<TsaiChartPoint> get _points =>
      _source == TsaiChartStatus.data ? barChartPointsFor(_period) : const [];

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('barChart-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiBarChart(
          points: _points,
          period: _period,
          status: _source,
          showTabs: _showTabs,
          onPeriodChanged: (value) => setState(() => _period = value),
          onRetry: () => setState(() => _source = TsaiChartStatus.data),
        ),
        controls: [
          PlaygroundSelectControl<TsaiChartStatus>(
            label: 'source',
            value: _source,
            values: const [
              TsaiChartStatus.loading,
              TsaiChartStatus.empty,
              TsaiChartStatus.data,
              TsaiChartStatus.error,
            ],
            labels: const ['Loading', 'Loaded empty', 'Loaded', 'Error'],
            onChanged: (value) => setState(() => _source = value),
          ),
          PlaygroundSelectControl<TsaiChartPeriod>(
            label: 'period',
            value: _period,
            values: TsaiChartPeriod.values,
            labels: [for (final period in TsaiChartPeriod.values) period.label],
            onChanged: (value) => setState(() => _period = value),
          ),
          PlaygroundToggleControl(
            label: 'tabs',
            value: _showTabs,
            onChanged: (value) => setState(() => _showTabs = value),
          ),
        ],
      ),
    ],
  );
}
