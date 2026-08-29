import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';
import 'chart_demo_data.dart';

class LineChartDemoScreen extends StatelessWidget {
  const LineChartDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.lineChart,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const _LineChartDemo(),
  );
}

class _LineChartDemo extends StatefulWidget {
  const _LineChartDemo();

  @override
  State<_LineChartDemo> createState() => _LineChartDemoState();
}

class _LineChartDemoState extends State<_LineChartDemo> {
  var _period = TsaiChartPeriod.oneMonth;
  var _source = TsaiChartStatus.data;
  var _showArea = true;
  var _showDot = true;
  var _showTabs = true;
  var _showGrid = false;
  var _showBaseline = false;
  var _showAxisY = false;
  var _showAxisX = false;

  List<TsaiChartPoint> get _points =>
      _source == TsaiChartStatus.data ? lineChartPointsFor(_period) : const [];

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('lineChart-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiLineChart(
          points: _points,
          period: _period,
          status: _source,
          showArea: _showArea,
          showDot: _showDot,
          showTabs: _showTabs,
          showGrid: _showGrid,
          showBaseline: _showBaseline,
          showAxisY: _showAxisY,
          showAxisX: _showAxisX,
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
            labels: const ['Not loaded', 'Loaded empty', 'Loaded', 'Error'],
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
            label: 'area',
            value: _showArea,
            onChanged: (value) => setState(() => _showArea = value),
          ),
          PlaygroundToggleControl(
            label: 'dot',
            value: _showDot,
            onChanged: (value) => setState(() => _showDot = value),
          ),
          PlaygroundToggleControl(
            label: 'tabs',
            value: _showTabs,
            onChanged: (value) => setState(() => _showTabs = value),
          ),
          PlaygroundToggleControl(
            label: 'grid',
            value: _showGrid,
            onChanged: (value) => setState(() => _showGrid = value),
          ),
          PlaygroundToggleControl(
            label: 'baseline',
            value: _showBaseline,
            onChanged: (value) => setState(() => _showBaseline = value),
          ),
          PlaygroundToggleControl(
            label: 'axis y',
            value: _showAxisY,
            onChanged: (value) => setState(() => _showAxisY = value),
          ),
          PlaygroundToggleControl(
            label: 'axis x',
            value: _showAxisX,
            onChanged: (value) => setState(() => _showAxisX = value),
          ),
        ],
      ),
    ],
  );
}
