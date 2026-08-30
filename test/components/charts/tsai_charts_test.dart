import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  Future<Uint8List> capturePlot(
    WidgetTester tester, {
    required Widget child,
  }) async {
    await pumpChart(
      tester,
      child: ColoredBox(
        color: const Color(0xFF15161F),
        child: RepaintBoundary(
          key: const ValueKey<String>('plot-capture'),
          child: child,
        ),
      ),
    );
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey<String>('plot-capture')),
    );
    late Uint8List out;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      out = bytes!.buffer.asUint8List();
    });
    return out;
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

  testWidgets(
    'Line Chart is 318 by 280 including overflow and shows empty copy',
    (tester) async {
      await pumpChart(
        tester,
        child: const TsaiLineChart(
          points: points,
          status: TsaiChartStatus.empty,
        ),
      );

      expect(tester.getSize(find.byType(TsaiLineChart)), const Size(318, 280));
      expect(find.text('No data for this period'), findsOneWidget);
    },
  );

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

  testWidgets('Bar Chart is 318 by 280 and ignores tabs while loading', (
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
    expect(period, isNull);
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
    expect(find.text('Mon'), findsOneWidget);
    await gesture.up();
    await tester.pump();
    expect(find.text(r'$10'), findsOneWidget);
  });

  testWidgets('Bar Chart hover shows the point tooltip date', (tester) async {
    await pumpChart(
      tester,
      child: const TsaiBarChart(
        points: points,
        period: TsaiChartPeriod.oneWeek,
      ),
    );
    final chart = tester.getRect(find.byType(TsaiBarChart));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer();
    addTearDown(mouse.removePointer);
    await mouse.moveTo(Offset(chart.left + 28, chart.top + 120));
    await tester.pump();
    expect(find.text('Mon'), findsOneWidget);
  });

  testWidgets(
    'Line Chart loading stroke is skeleton and area is 20% slate fade',
    (tester) async {
      const canvas = Color(0xFF15161F);
      const skeleton = Color(0xFF1C1C20);
      // `#8C8FA6` at 20% over Penpot card `#15161F` at the top of the area.
      const areaTop = Color(0xFF2D2E3A);
      await pumpChart(
        tester,
        child: const RepaintBoundary(
          key: ValueKey<String>('loading-line-capture'),
          child: ColoredBox(
            color: canvas,
            child: TsaiLineChart(points: [], status: TsaiChartStatus.loading),
          ),
        ),
      );

      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const ValueKey<String>('loading-line-capture')),
      );
      ui.Image? image;
      ByteData? bytes;
      await tester.runAsync(() async {
        image = await boundary.toImage(pixelRatio: 1);
        bytes = await image!.toByteData(format: ui.ImageByteFormat.rawRgba);
      });
      expect(bytes, isNotNull);
      expect(image, isNotNull);
      final data = bytes!.buffer.asUint8List();
      final width = image!.width;

      int dist(int index, Color color) {
        final red = (color.r * 255).round();
        final green = (color.g * 255).round();
        final blue = (color.b * 255).round();
        return (data[index] - red).abs() +
            (data[index + 1] - green).abs() +
            (data[index + 2] - blue).abs();
      }

      var closestSkeleton = 999;
      var closestAreaTop = 999;
      for (var y = 50; y < 190; y++) {
        for (var x = 16; x < width - 16; x++) {
          final index = (y * width + x) * 4;
          closestSkeleton = math.min(closestSkeleton, dist(index, skeleton));
          closestAreaTop = math.min(closestAreaTop, dist(index, areaTop));
        }
      }
      expect(closestSkeleton, lessThan(16));
      expect(closestAreaTop, lessThan(16));

      var maxFloor = 0;
      for (var y = 204; y < 222; y++) {
        for (var x = 24; x < width - 24; x++) {
          final index = (y * width + x) * 4;
          maxFloor = math.max(maxFloor, dist(index, canvas));
        }
      }
      expect(maxFloor, lessThan(36));
    },
  );

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

  testWidgets('Line Chart ignores Mini Tabs while loading', (tester) async {
    TsaiChartPeriod? period;
    await pumpChart(
      tester,
      child: TsaiLineChart(
        points: const [],
        status: TsaiChartStatus.loading,
        onPeriodChanged: (value) => period = value,
      ),
    );
    await tester.tap(find.text('1Y'));
    await tester.pump();
    expect(period, isNull);
  });

  testWidgets(
    'Bar Chart first-load skeleton does not follow the selected period',
    (tester) async {
      final day = await capturePlot(
        tester,
        child: const TsaiBarChart(
          points: [],
          status: TsaiChartStatus.loading,
          period: TsaiChartPeriod.oneDay,
          showTabs: false,
        ),
      );
      final year = await capturePlot(
        tester,
        child: const TsaiBarChart(
          points: [],
          status: TsaiChartStatus.loading,
          period: TsaiChartPeriod.oneYear,
          showTabs: false,
        ),
      );
      expect(day, year);
    },
  );

  testWidgets('Bar Chart loading after data keeps the previous bars', (
    tester,
  ) async {
    var status = TsaiChartStatus.data;
    late StateSetter setHost;
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  setHost = setState;
                  return ColoredBox(
                    color: const Color(0xFF15161F),
                    child: RepaintBoundary(
                      key: const ValueKey<String>('retain-capture'),
                      child: TsaiBarChart(
                        points: status == TsaiChartStatus.data
                            ? points
                            : const [],
                        status: status,
                        period: TsaiChartPeriod.oneWeek,
                        showTabs: false,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    setHost(() => status = TsaiChartStatus.loading);
    await tester.pump();

    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey<String>('retain-capture')),
    );
    late Uint8List retained;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      retained = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!.buffer.asUint8List();
    });
    final canonical = await capturePlot(
      tester,
      child: const TsaiBarChart(
        points: [],
        status: TsaiChartStatus.loading,
        period: TsaiChartPeriod.oneWeek,
        showTabs: false,
      ),
    );
    expect(retained, isNot(canonical));
  });

  testWidgets('Bar Chart loading after error uses the canonical skeleton', (
    tester,
  ) async {
    var status = TsaiChartStatus.error;
    late StateSetter setHost;
    await tester.pumpWidget(
      MaterialApp(
        theme: TsaiTheme.dark(),
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  setHost = setState;
                  return ColoredBox(
                    color: const Color(0xFF15161F),
                    child: RepaintBoundary(
                      key: const ValueKey<String>('error-loading-capture'),
                      child: TsaiBarChart(
                        points: const [],
                        status: status,
                        period: TsaiChartPeriod.oneWeek,
                        showTabs: false,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    setHost(() => status = TsaiChartStatus.loading);
    await tester.pump();
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(const ValueKey<String>('error-loading-capture')),
    );
    late Uint8List afterError;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      afterError = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!.buffer.asUint8List();
    });
    final canonical = await capturePlot(
      tester,
      child: const TsaiBarChart(
        points: [],
        status: TsaiChartStatus.loading,
        period: TsaiChartPeriod.oneWeek,
        showTabs: false,
      ),
    );
    expect(afterError, canonical);
  });
}
