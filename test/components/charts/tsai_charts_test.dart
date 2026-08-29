import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  const points = [
    TsaiChartPoint(
      value: 10,
      tooltipValue: r'$10',
      tooltipDate: 'Mon',
      axisLabel: 'M',
    ),
    TsaiChartPoint(
      value: 20,
      tooltipValue: r'$20',
      tooltipDate: 'Tue',
      axisLabel: 'T',
    ),
    TsaiChartPoint(
      value: 14,
      tooltipValue: r'$14',
      tooltipDate: 'Wed',
      axisLabel: 'W',
    ),
    TsaiChartPoint(
      value: 28,
      tooltipValue: r'$28',
      tooltipDate: 'Thu',
      axisLabel: 'T',
    ),
    TsaiChartPoint(
      value: 18,
      tooltipValue: r'$18',
      tooltipDate: 'Fri',
      axisLabel: 'F',
    ),
    TsaiChartPoint(
      value: 8,
      tooltipValue: r'$8',
      tooltipDate: 'Sat',
      axisLabel: 'S',
    ),
    TsaiChartPoint(
      value: 22,
      tooltipValue: r'$22',
      tooltipDate: 'Sun',
      axisLabel: 'S',
    ),
  ];

  Future<void> pumpChart(WidgetTester tester, {required Widget child}) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(body: Center(child: child)),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('Mini Tabs is 294 by 28 and reports the tapped index', (
    tester,
  ) async {
    var selected = 2;
    await pumpChart(
      tester,
      child: TsaiMiniTabs(
        labels: const ['1D', '1W', '1M', '1Y', 'All'],
        selectedIndex: selected,
        onChanged: (index) => selected = index,
      ),
    );

    expect(tester.getSize(find.byType(TsaiMiniTabs)), const Size(294, 28));
    await tester.tap(find.text('1W'));
    await tester.pump();
    expect(selected, 1);
  });

  testWidgets('Line Chart is 294 by 256 and shows empty copy', (tester) async {
    await pumpChart(
      tester,
      child: const TsaiLineChart(points: points, status: TsaiChartStatus.empty),
    );

    expect(tester.getSize(find.byType(TsaiLineChart)), const Size(294, 256));
    expect(find.text('No data for this period'), findsOneWidget);
  });

  testWidgets('Line Chart error retry fires', (tester) async {
    var retried = false;
    await pumpChart(
      tester,
      child: TsaiLineChart(
        points: points,
        status: TsaiChartStatus.error,
        onRetry: () => retried = true,
      ),
    );

    expect(find.text("Couldn't load chart"), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(retried, isTrue);
  });

  testWidgets('Bar Chart is 294 by 256 and keeps tabs while loading', (
    tester,
  ) async {
    TsaiChartPeriod? period;
    await pumpChart(
      tester,
      child: TsaiBarChart(
        points: points,
        status: TsaiChartStatus.loading,
        period: TsaiChartPeriod.oneWeek,
        onPeriodChanged: (value) => period = value,
      ),
    );

    expect(tester.getSize(find.byType(TsaiBarChart)), const Size(294, 256));
    await tester.tap(find.text('1Y'));
    await tester.pump();
    expect(period, TsaiChartPeriod.oneYear);
  });

  testWidgets('Line Chart scrub shows the tooltip value', (tester) async {
    await pumpChart(tester, child: const TsaiLineChart(points: points));
    final chart = tester.getRect(find.byType(TsaiLineChart));
    final gesture = await tester.startGesture(
      Offset(chart.left + 8, chart.top + 120),
    );
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text(r'$10'), findsOneWidget);
    await gesture.up();
  });
}
