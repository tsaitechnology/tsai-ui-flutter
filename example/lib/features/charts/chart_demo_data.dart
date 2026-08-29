import 'package:tsai_ui/tsai_ui.dart';

List<TsaiChartPoint> lineChartPointsFor(TsaiChartPeriod period) {
  final values = switch (period) {
    TsaiChartPeriod.oneDay => const [
      12.1,
      12.4,
      11.8,
      12.0,
      12.6,
      13.1,
      12.8,
      13.4,
      13.9,
      13.2,
      14.0,
      14.6,
      14.1,
      15.2,
      15.8,
      15.1,
      16.0,
      16.4,
      16.1,
      16.8,
      17.1,
      16.6,
      17.0,
      17.4,
    ],
    TsaiChartPeriod.oneWeek => const [14.2, 13.8, 15.1, 16.4, 15.9, 16.8, 17.2],
    TsaiChartPeriod.oneMonth => const [
      12.4,
      12.8,
      13.1,
      12.6,
      13.8,
      14.2,
      13.6,
      14.8,
      15.4,
      14.9,
      15.8,
      16.2,
      15.6,
      16.4,
      17.2,
      16.8,
      16.1,
      16.9,
      17.4,
      16.6,
      17.0,
      17.6,
      17.1,
      17.8,
    ],
    TsaiChartPeriod.oneYear => const [
      10.2,
      11.4,
      10.8,
      12.6,
      13.1,
      12.4,
      14.8,
      15.2,
      14.6,
      16.1,
      16.8,
      17.4,
    ],
    TsaiChartPeriod.all => const [8.4, 9.8, 11.2, 13.6, 15.1, 17.4],
  };
  return [
    for (var index = 0; index < values.length; index++)
      TsaiChartPoint(
        value: values[index] * 1000,
        tooltipValue: '\$${(values[index] * 1000).toStringAsFixed(2)}',
        tooltipDate: 'Jul ${index + 1}, 2026',
      ),
  ];
}

List<TsaiChartPoint> barChartPointsFor(TsaiChartPeriod period) {
  final (values, labels) = switch (period) {
    TsaiChartPeriod.oneDay => (
      List<double>.generate(24, (index) => 20 + ((index * 17) % 90).toDouble()),
      List<String>.generate(
        24,
        (index) => index % 6 == 0 ? index.toString().padLeft(2, '0') : '',
      ),
    ),
    TsaiChartPeriod.oneWeek => (
      const [59.0, 98.0, 42.0, 140.0, 76.0, 28.0, 102.0],
      const ['M', 'T', 'W', 'T', 'F', 'S', 'S'],
    ),
    TsaiChartPeriod.oneMonth => (
      List<double>.generate(
        30,
        (index) => 18 + ((index * 13) % 120).toDouble(),
      ),
      List<String>.generate(
        30,
        (index) => (index % 7 == 0) ? '${index + 1}' : '',
      ),
    ),
    TsaiChartPeriod.oneYear => (
      const [
        52.0,
        76.0,
        60.0,
        96.0,
        44.0,
        88.0,
        70.0,
        110.0,
        64.0,
        82.0,
        94.0,
        120.0,
      ],
      const ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'],
    ),
    TsaiChartPeriod.all => (
      const [36.0, 58.0, 72.0, 96.0, 112.0, 140.0],
      const ['2021', '2022', '2023', '2024', '2025', '2026'],
    ),
  };
  return [
    for (var index = 0; index < values.length; index++)
      TsaiChartPoint(
        value: values[index],
        tooltipValue: '\$${values[index].toStringAsFixed(0)}',
        tooltipDate: labels[index].isEmpty ? 'Day ${index + 1}' : labels[index],
        axisLabel: labels[index],
      ),
  ];
}
