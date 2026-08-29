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
  var _status = TsaiChartStatus.data;
  var _showArea = true;
  var _showDot = true;
  var _showTabs = true;
  var _showGrid = false;
  var _showBaseline = false;

  @override
  Widget build(BuildContext context) => ListView(
    key: const ValueKey<String>('lineChart-demo'),
    padding: const EdgeInsets.all(24),
    children: [
      ComponentPlayground(
        preview: TsaiLineChart(
          points: lineChartPointsFor(_period),
          period: _period,
          status: _status,
          showArea: _showArea,
          showDot: _showDot,
          showTabs: _showTabs,
          showGrid: _showGrid,
          showBaseline: _showBaseline,
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
        ],
      ),
    ],
  );
}
