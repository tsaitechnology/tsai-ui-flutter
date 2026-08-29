import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import 'src/tsai_chart_chrome.dart';
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

  /// Optional accessibility name for the chart.
  final String? semanticLabel;

  @override
  State<TsaiBarChart> createState() => _TsaiBarChartState();
}

class _TsaiBarChartState extends State<TsaiBarChart>
    with SingleTickerProviderStateMixin {
  int? _scrubIndex;
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncShimmer();
  }

  @override
  void didUpdateWidget(covariant TsaiBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncShimmer();
  }

  void _syncShimmer() {
    final reduce = MediaQuery.disableAnimationsOf(context);
    if (widget.status == TsaiChartStatus.loading && !reduce) {
      if (!_shimmer.isAnimating) {
        _shimmer.repeat();
      }
    } else {
      _shimmer
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
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
    final layout = _TsaiBarChartLayout.forPeriod(widget.period, tokens);
    final periods = TsaiChartPeriod.values;
    return Semantics(
      label: widget.semanticLabel ?? 'Bar chart',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(tokens.radii.card),
        child: SizedBox(
          key: const ValueKey<String>('tsai-bar-chart'),
          width: TsaiChartMetrics.width,
          height: TsaiChartMetrics.height,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onLongPressStart: widget.status == TsaiChartStatus.data
                      ? (details) => setState(
                          () => _scrubIndex = _indexForDx(
                            details.localPosition.dx,
                            layout,
                          ),
                        )
                      : null,
                  onLongPressMoveUpdate: widget.status == TsaiChartStatus.data
                      ? (details) => setState(
                          () => _scrubIndex = _indexForDx(
                            details.localPosition.dx,
                            layout,
                          ),
                        )
                      : null,
                  onLongPressEnd: (_) => setState(() => _scrubIndex = null),
                  child: AnimatedBuilder(
                    animation: _shimmer,
                    builder: (context, child) => CustomPaint(
                      painter: _BarChartPainter(
                        tokens: tokens,
                        points: widget.points,
                        layout: layout,
                        status: widget.status,
                        scrubIndex: _scrubIndex,
                        shimmer: _shimmer.value,
                      ),
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
              Positioned(
                top: TsaiChartMetrics.tabsTop,
                child: TsaiMiniTabs(
                  labels: [for (final period in periods) period.label],
                  selectedIndex: periods.indexOf(widget.period),
                  onChanged: widget.onPeriodChanged == null
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
    required this.scrubIndex,
    required this.shimmer,
  });

  final TsaiThemeTokens tokens;
  final List<TsaiChartPoint> points;
  final _TsaiBarChartLayout layout;
  final TsaiChartStatus status;
  final int? scrubIndex;
  final double shimmer;

  @override
  void paint(Canvas canvas, Size size) {
    if (status == TsaiChartStatus.empty || status == TsaiChartStatus.error) {
      return;
    }
    final values = [
      for (
        var index = 0;
        index < math.min(layout.count, points.length);
        index++
      )
        points[index].value,
    ];
    if (values.isEmpty && status != TsaiChartStatus.loading) {
      return;
    }
    final fallback = const [59.0, 98.0, 42.0, 140.0, 76.0, 28.0, 102.0];
    final series = values.isEmpty ? fallback : values;
    final maxValue = series.reduce((a, b) => a > b ? a : b);
    final barCount = status == TsaiChartStatus.loading
        ? layout.count
        : math.min(layout.count, points.length);

    for (var index = 0; index < barCount; index++) {
      final value = index < series.length
          ? series[index]
          : fallback[index % fallback.length];
      final height = maxValue == 0
          ? 0.0
          : TsaiChartMetrics.barPlotHeight *
                (value / (maxValue == 0 ? 1 : maxValue));
      final x = layout.xFor(index);
      final rect = RRect.fromLTRBAndCorners(
        x,
        TsaiChartMetrics.barPlotBottom - height,
        x + layout.barWidth,
        TsaiChartMetrics.barPlotBottom,
        topLeft: Radius.circular(layout.topRadius),
        topRight: Radius.circular(layout.topRadius),
      );
      if (status == TsaiChartStatus.loading) {
        canvas.drawRRect(rect, Paint()..color = tokens.colors.surfaceSkeleton);
        final offset = -3 + shimmer * 6;
        canvas.saveLayer(rect.outerRect, Paint());
        canvas.drawRRect(rect, Paint()..color = const Color(0x338C8FA6));
        canvas.drawRect(
          rect.outerRect,
          Paint()
            ..blendMode = BlendMode.srcATop
            ..shader = LinearGradient(
              begin: Alignment(0, offset - 1),
              end: Alignment(0, offset + 1),
              colors: const [
                Color(0x008C8FA6),
                Color(0x338C8FA6),
                Color(0x008C8FA6),
              ],
            ).createShader(rect.outerRect),
        );
        canvas.restore();
      } else {
        final muted = scrubIndex != null && scrubIndex != index;
        canvas.drawRRect(
          rect,
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
      final paint = Paint()
        ..color = tokens.colors.borderGuide
        ..strokeWidth = 1;
      canvas.drawLine(Offset(x, 44), Offset(x, 53), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.layout != layout ||
      oldDelegate.status != status ||
      oldDelegate.scrubIndex != scrubIndex ||
      oldDelegate.shimmer != shimmer ||
      oldDelegate.tokens != tokens;
}
