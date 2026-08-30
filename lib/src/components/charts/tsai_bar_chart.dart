import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import 'src/tsai_chart_chrome.dart';
import 'src/tsai_chart_frame.dart';
import 'src/tsai_chart_scrub.dart';
import 'tsai_chart_types.dart';
import 'tsai_mini_tabs.dart';

@immutable
final class _TsaiBarChartLayout {
  /// Creates a bar layout.
  const _TsaiBarChartLayout({
    required this.count,
    required this.barWidth,
    required this.gap,
    required this.topRadius,
  });

  /// Layout for [period].
  factory _TsaiBarChartLayout.forPeriod(
    TsaiChartPeriod period,
    TsaiThemeTokens tokens,
  ) => switch (period) {
    TsaiChartPeriod.oneDay => _TsaiBarChartLayout(
      count: 24,
      barWidth: 9.38,
      gap: 3,
      topRadius: tokens.radii.extraSmall,
    ),
    TsaiChartPeriod.oneWeek => _TsaiBarChartLayout(
      count: 7,
      barWidth: 32,
      gap: 11.67,
      topRadius: tokens.radii.small,
    ),
    TsaiChartPeriod.oneMonth => _TsaiBarChartLayout(
      count: 30,
      barWidth: 7.87,
      gap: 2,
      topRadius: tokens.radii.extraSmall,
    ),
    TsaiChartPeriod.oneYear => _TsaiBarChartLayout(
      count: 12,
      barWidth: 19,
      gap: 6,
      topRadius: tokens.radii.small,
    ),
    TsaiChartPeriod.all => _TsaiBarChartLayout(
      count: 6,
      barWidth: 39,
      gap: 12,
      topRadius: tokens.radii.small,
    ),
  };

  /// Number of bars that fit the 294-pixel plot.
  final int count;

  /// Bar width in pixels.
  final double barWidth;

  /// Gap between bars.
  final double gap;

  /// Top-corner radius. Bottom corners stay square.
  final double topRadius;

  /// Left edge of the bar at [index].
  double xFor(int index) => index * (barWidth + gap);
}

/// Vertical bar chart matching the Penpot Bar Chart.
class TsaiBarChart extends StatefulWidget {
  /// Creates a bar chart.
  const TsaiBarChart({
    required this.points,
    super.key,
    this.status = TsaiChartStatus.data,
    this.period = TsaiChartPeriod.oneWeek,
    this.onPeriodChanged,
    this.onRetry,
    this.onScrubIndexChanged,
    this.showTabs = true,
    this.semanticLabel,
  });

  /// One point per bar. Extra points are ignored; missing bars are omitted.
  final List<TsaiChartPoint> points;

  /// Loading, empty, error, or data.
  final TsaiChartStatus status;

  /// Active period. Controls bar count, width, gap, and Mini Tabs.
  final TsaiChartPeriod period;

  /// Called when a Mini Tab is selected.
  final ValueChanged<TsaiChartPeriod>? onPeriodChanged;

  /// Called from the error-state retry link.
  final VoidCallback? onRetry;

  /// Called when a hold-to-scrub index is committed or cleared.
  final ValueChanged<int?>? onScrubIndexChanged;

  /// Whether to show Mini Tabs.
  final bool showTabs;

  /// Optional accessibility name for the chart.
  final String? semanticLabel;

  @override
  State<TsaiBarChart> createState() => _TsaiBarChartState();
}

class _TsaiBarChartState extends State<TsaiBarChart> {
  int? _hoverIndex;
  int? _holdIndex;
  int? _stickyIndex;
  final _memory = TsaiChartSeriesMemory();

  int? get _scrubIndex => _holdIndex ?? _hoverIndex ?? _stickyIndex;

  void _notifyScrub() => widget.onScrubIndexChanged?.call(_stickyIndex);

  @override
  void initState() {
    super.initState();
    _syncMemory();
  }

  @override
  void didUpdateWidget(covariant TsaiBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status ||
        widget.period != oldWidget.period) {
      _hoverIndex = null;
      _holdIndex = null;
      _stickyIndex = null;
      widget.onScrubIndexChanged?.call(null);
    }
    _syncMemory();
  }

  void _syncMemory() {
    _memory.sync(
      status: widget.status,
      incoming: widget.points,
      incomingPeriod: widget.period,
    );
  }

  int _indexForDx(double dx, _TsaiBarChartLayout layout) {
    final count = math.min(layout.count, widget.points.length);
    if (count == 0) {
      return 0;
    }
    final raw = ((dx + layout.gap / 2) / (layout.barWidth + layout.gap))
        .floor();
    return raw.clamp(0, count - 1);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final layoutPeriod =
        widget.status == TsaiChartStatus.loading && !_memory.hasPoints
        ? TsaiChartPeriod.oneWeek
        : widget.status == TsaiChartStatus.loading && _memory.period != null
        ? _memory.period!
        : widget.period;
    final layout = _TsaiBarChartLayout.forPeriod(layoutPeriod, tokens);
    final periods = TsaiChartPeriod.values;
    return Semantics(
      label: widget.semanticLabel ?? 'Bar chart',
      child: TsaiChartFrame(
        child: SizedBox(
          key: const ValueKey<String>('tsai-bar-chart'),
          width: TsaiChartMetrics.width,
          height: TsaiChartMetrics.height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: TsaiChartScrubListener(
                  enabled:
                      widget.status == TsaiChartStatus.data &&
                      widget.points.isNotEmpty,
                  onHoverDx: (dx) => setState(() {
                    _hoverIndex = _indexForDx(dx, layout);
                  }),
                  onHoverEnd: () => setState(() => _hoverIndex = null),
                  onHoldDx: (dx) => setState(() {
                    _holdIndex = _indexForDx(dx, layout);
                  }),
                  onHoldEnd: () {
                    setState(() {
                      _stickyIndex = _holdIndex ?? _stickyIndex;
                      _holdIndex = null;
                    });
                    _notifyScrub();
                  },
                  child: CustomPaint(
                    painter: _BarChartPainter(
                      tokens: tokens,
                      points: widget.status == TsaiChartStatus.loading
                          ? (_memory.points ?? const [])
                          : widget.points,
                      layout: layout,
                      status: widget.status,
                      canonicalLoading:
                          widget.status == TsaiChartStatus.loading &&
                          !_memory.hasPoints,
                      scrubIndex: _scrubIndex,
                    ),
                  ),
                ),
              ),
              if (widget.status == TsaiChartStatus.empty)
                Positioned(
                  top: TsaiChartMetrics.plotTop,
                  child: TsaiChartChrome.empty(tokens: tokens),
                ),
              if (widget.status == TsaiChartStatus.error)
                Positioned(
                  top: TsaiChartMetrics.plotTop,
                  child: TsaiChartChrome.error(
                    tokens: tokens,
                    onRetry: widget.onRetry,
                  ),
                ),
              if (_scrubIndex != null && widget.points.isNotEmpty)
                TsaiChartChrome.tooltip(
                  tokens: tokens,
                  value: widget.points[_scrubIndex!].tooltipValue,
                  date: widget.points[_scrubIndex!].tooltipDate,
                  anchorX: layout.xFor(_scrubIndex!) + layout.barWidth / 2,
                  maxWidth: TsaiChartMetrics.width,
                ),
              if (widget.showTabs)
                Positioned(
                  top: TsaiChartMetrics.tabsTop,
                  child: TsaiMiniTabs(
                    labels: [for (final period in periods) period.label],
                    selectedIndex: periods.indexOf(widget.period),
                    onChanged:
                        widget.status == TsaiChartStatus.loading ||
                            widget.onPeriodChanged == null
                        ? null
                        : (index) => widget.onPeriodChanged!(periods[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  const _BarChartPainter({
    required this.tokens,
    required this.points,
    required this.layout,
    required this.status,
    required this.canonicalLoading,
    required this.scrubIndex,
  });

  final TsaiThemeTokens tokens;
  final List<TsaiChartPoint> points;
  final _TsaiBarChartLayout layout;
  final TsaiChartStatus status;
  final bool canonicalLoading;
  final int? scrubIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (status == TsaiChartStatus.empty || status == TsaiChartStatus.error) {
      return;
    }
    final values = [
      if (status == TsaiChartStatus.loading && canonicalLoading)
        ...tsaiChartLoadingBarHeights
      else
        for (
          var index = 0;
          index < math.min(layout.count, points.length);
          index++
        )
          points[index].value,
    ];
    if (values.isEmpty) {
      return;
    }
    final series = values;
    final maxValue = status == TsaiChartStatus.loading && canonicalLoading
        ? TsaiChartMetrics.barPlotHeight
        : series.reduce((a, b) => a > b ? a : b);
    final barCount = series.length;
    final bars = <RRect>[
      for (var index = 0; index < barCount; index++)
        RRect.fromLTRBAndCorners(
          layout.xFor(index),
          TsaiChartMetrics.barPlotBottom - _barHeight(series[index], maxValue),
          layout.xFor(index) + layout.barWidth,
          TsaiChartMetrics.barPlotBottom,
          topLeft: Radius.circular(layout.topRadius),
          topRight: Radius.circular(layout.topRadius),
        ),
    ];

    if (status == TsaiChartStatus.loading) {
      final skeleton = Paint()..color = tokens.colors.surfaceSkeleton;
      for (final rect in bars) {
        canvas.drawRRect(rect, skeleton);
      }
    } else {
      for (var index = 0; index < barCount; index++) {
        final muted = scrubIndex != null && scrubIndex != index;
        canvas.drawRRect(
          bars[index],
          Paint()
            ..color = muted
                ? tokens.colors.actionPrimaryMuted
                : tokens.colors.actionPrimary,
        );
      }
    }

    if (status == TsaiChartStatus.data) {
      final style = tokens.typography.captionExtraSmallRegular.copyWith(
        color: tokens.colors.contentTertiary,
      );
      for (
        var index = 0;
        index < math.min(layout.count, points.length);
        index++
      ) {
        final label = points[index].axisLabel;
        if (label.isEmpty) {
          continue;
        }
        final painter = TextPainter(
          text: TextSpan(text: label, style: style),
          textDirection: TextDirection.ltr,
        )..layout();
        final x = layout.xFor(index) + layout.barWidth / 2 - painter.width / 2;
        painter.paint(canvas, Offset(x, 204));
      }
    }

    if (scrubIndex != null && status == TsaiChartStatus.data) {
      final x = layout.xFor(scrubIndex!) + layout.barWidth / 2;
      final barTop =
          TsaiChartMetrics.barPlotBottom -
          _barHeight(series[scrubIndex!], maxValue);
      tsaiDrawDashedLine(
        canvas,
        Offset(x, TsaiChartMetrics.tooltipZoneHeight),
        Offset(x, barTop),
        Paint()
          ..color = tokens.colors.borderGuide
          ..strokeWidth = 1,
      );
    }
  }

  static double _barHeight(double value, double maxValue) =>
      maxValue == 0 ? 0.0 : TsaiChartMetrics.barPlotHeight * (value / maxValue);

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.layout != layout ||
      oldDelegate.status != status ||
      oldDelegate.canonicalLoading != canonicalLoading ||
      oldDelegate.scrubIndex != scrubIndex ||
      oldDelegate.tokens != tokens;
}
