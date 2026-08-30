import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';
import 'package:tsai_ui_example/features/charts/chart_demo_data.dart';

void main() {
  test('bar chart 1D tooltips use hours, not day numbers', () {
    final points = barChartPointsFor(TsaiChartPeriod.oneDay);
    expect(points, hasLength(24));
    expect(points.first.tooltipDate, '00:00');
    expect(points[13].tooltipDate, '13:00');
    expect(points.last.tooltipDate, '23:00');
  });

  test('bar chart 1W tooltips use full weekday names', () {
    final points = barChartPointsFor(TsaiChartPeriod.oneWeek);
    expect(points.map((point) => point.tooltipDate).toList(), [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ]);
  });

  test('bar chart 1M tooltips use calendar dates', () {
    final points = barChartPointsFor(TsaiChartPeriod.oneMonth);
    expect(points.first.tooltipDate, 'Jul 1, 2026');
    expect(points[15].tooltipDate, 'Jul 16, 2026');
    expect(points.last.tooltipDate, 'Jul 30, 2026');
  });

  test('bar chart 1Y tooltips use full month names', () {
    final points = barChartPointsFor(TsaiChartPeriod.oneYear);
    expect(points.first.tooltipDate, 'January');
    expect(points[8].tooltipDate, 'September');
    expect(points.last.tooltipDate, 'December');
  });
}
