import 'package:flutter/foundation.dart';

/// Time window selected by Mini Tabs on Tsai charts.
enum TsaiChartPeriod {
  /// Hourly window labeled `1D`.
  oneDay('1D'),

  /// Daily window labeled `1W`.
  oneWeek('1W'),

  /// Daily window labeled `1M`.
  oneMonth('1M'),

  /// Monthly window labeled `1Y`.
  oneYear('1Y'),

  /// Multi-year window labeled `All`.
  all('All');

  const TsaiChartPeriod(this.label);

  /// Mini Tab label for this period.
  final String label;
}

/// Visual status of a Tsai chart besides the press-and-hold scrub overlay.
enum TsaiChartStatus {
  /// Renders the series.
  data,

  /// Renders the skeleton silhouette. Mini Tabs stay interactive.
  loading,

  /// Renders the empty caption and baseline.
  empty,

  /// Renders the retry block.
  error,
}

/// One plotted value with tooltip copy.
@immutable
final class TsaiChartPoint {
  /// Creates a chart sample.
  const TsaiChartPoint({
    required this.value,
    required this.tooltipValue,
    required this.tooltipDate,
    this.axisLabel = '',
  });

  /// Numeric magnitude plotted on the y axis.
  final double value;

  /// Primary tooltip line, including currency.
  final String tooltipValue;

  /// Secondary tooltip line, typically a date.
  final String tooltipDate;

  /// Optional x-axis tick shown under bar charts.
  final String axisLabel;
}

/// Shared geometry from the Penpot Charts page.
abstract final class TsaiChartMetrics {
  /// Root width of Line Chart, Bar Chart, and Mini Tabs.
  static const double width = 294;

  /// Root height of Line Chart and Bar Chart.
  static const double height = 256;

  /// Tooltip zone height.
  static const double tooltipZoneHeight = 44;

  /// Top of the plot, 12 pixels below the tooltip zone.
  static const double plotTop = 56;

  /// Line-chart plot bottom.
  static const double linePlotBottom = 216;

  /// Bar-chart plot bottom.
  static const double barPlotBottom = 196;

  /// Bar-chart plot height.
  static const double barPlotHeight = 140;

  /// Peak of the line keeps this clearance below the tooltip zone.
  static const double peakClearance = 20;

  /// Mini Tabs y origin.
  static const double tabsTop = 228;

  /// Mini Tabs height.
  static const double tabsHeight = 28;
}
