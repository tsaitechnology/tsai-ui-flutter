import 'package:flutter/gestures.dart';
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

  testWidgets('Line Chart is 318 by 280 including overflow and shows empty copy', (tester) async {
    await pumpChart(
      tester,
      child: const TsaiLineChart(points: points, status: TsaiChartStatus.empty),
    );

    expect(tester.getSize(find.byType(TsaiLineChart)), const Size(318, 280));
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

  testWidgets('Bar Chart is 318 by 280 and keeps tabs while loading', (
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

    expect(tester.getSize(find.byType(TsaiBarChart)), const Size(318, 280));
    await tester.tap(find.text('1Y'));
    await tester.pump();
    expect(period, TsaiChartPeriod.oneYear);
  });

  testWidgets('Line Chart hold scrubs and keeps the tooltip after release', (
    tester,
  ) async {
    int? committed;
    await pumpChart(
      tester,
      child: TsaiLineChart(
        points: points,
        onScrubIndexChanged: (index) => committed = index,
      ),
    );
    final chart = tester.getRect(find.byType(TsaiLineChart));
    final gesture = await tester.startGesture(
      Offset(chart.left + 20, chart.top + 120),
    );
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text(r'$10'), findsOneWidget);
    await gesture.up();
    await tester.pump();
    expect(find.text(r'$10'), findsOneWidget);
    expect(committed, 0);
  });

  testWidgets('Line Chart mouse hover scrubs and pins the tooltip', (
    tester,
  ) async {
    await pumpChart(tester, child: const TsaiLineChart(points: points));
    final chart = tester.getRect(find.byType(TsaiLineChart));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer();
    addTearDown(mouse.removePointer);
    await mouse.moveTo(chart.center);
    await tester.pump();
    expect(find.text(r'$28'), findsOneWidget);
    await mouse.moveTo(Offset(chart.right - 16, chart.center.dy));
    await tester.pump();
    expect(find.text(r'$22'), findsOneWidget);
  });

  testWidgets('Bar Chart hold highlights a bar and stays after release', (
    tester,
  ) async {
    await pumpChart(
      tester,
      child: const TsaiBarChart(
        points: points,
        period: TsaiChartPeriod.oneWeek,
      ),
    );
    final chart = tester.getRect(find.byType(TsaiBarChart));
    final gesture = await tester.startGesture(
      Offset(chart.left + 28, chart.top + 120),
    );
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text(r'$10'), findsOneWidget);
    await gesture.up();
    await tester.pump();
    expect(find.text(r'$10'), findsOneWidget);
  });

  testWidgets('Line Chart shrinks to a narrow parent instead of clipping', (
    tester,
  ) async {
    await pumpChart(
      tester,
      child: const SizedBox(width: 200, child: TsaiLineChart(points: points)),
    );
    expect(tester.getSize(find.byType(TsaiLineChart)).width, 200);
    expect(
      tester.getSize(find.byType(TsaiLineChart)).height,
      closeTo(175.94, 0.2),
    );
  });
}
