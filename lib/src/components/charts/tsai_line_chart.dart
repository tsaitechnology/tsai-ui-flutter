import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import 'src/tsai_chart_chrome.dart';
import 'src/tsai_chart_frame.dart';
import 'src/tsai_chart_scrub.dart';
import 'tsai_chart_types.dart';
import 'tsai_mini_tabs.dart';

/// Smooth trend chart matching the Penpot Line Chart.
class TsaiLineChart extends StatefulWidget {
  /// Creates a line chart.
  const TsaiLineChart({
    required this.points,
    super.key,
    this.status = TsaiChartStatus.data,
    this.period = TsaiChartPeriod.oneMonth,
    this.onPeriodChanged,
    this.onRetry,
    this.onScrubIndexChanged,
    this.showGrid = false,
    this.showBaseline = false,
    this.showAxisY = false,
    this.showAxisX = false,
    this.showArea = true,
    this.showDot = true,
    this.showTabs = true,
    this.semanticLabel,
  });

  /// Series in chronological order.
  final List<TsaiChartPoint> points;

  /// Loading, empty, error, or data.
  final TsaiChartStatus status;

  /// Active Mini Tabs segment.
  final TsaiChartPeriod period;

  /// Called when a Mini Tab is selected.
  final ValueChanged<TsaiChartPeriod>? onPeriodChanged;

  /// Called from the error-state retry link.
  final VoidCallback? onRetry;

  /// Called when a hold-to-scrub index is committed or cleared.
  ///
  /// Hover does not invoke this. After the pointer is released the last
  /// index stays selected until [status] or [period] changes.
  final ValueChanged<int?>? onScrubIndexChanged;

  /// Whether to paint the optional grid.
  final bool showGrid;

  /// Whether to paint the plot baseline.
  final bool showBaseline;

  /// Whether to paint y-axis values.
  final bool showAxisY;

  /// Whether to paint x-axis labels.
  final bool showAxisX;

  /// Whether to fill the area under the curve.
  final bool showArea;

  /// Whether to show the endpoint dot in the default state.
  final bool showDot;

  /// Whether to show Mini Tabs.
  final bool showTabs;

  /// Optional accessibility name for the chart.
  final String? semanticLabel;

  @override
  State<TsaiLineChart> createState() => _TsaiLineChartState();
}

class _TsaiLineChartState extends State<TsaiLineChart>
    with SingleTickerProviderStateMixin {
  int? _hoverIndex;
  int? _holdIndex;
  int? _stickyIndex;
  late final AnimationController _shimmer = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  int? get _scrubIndex => _holdIndex ?? _hoverIndex ?? _stickyIndex;

  void _notifyScrub() => widget.onScrubIndexChanged?.call(_stickyIndex);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncShimmer();
  }

  @override
  void didUpdateWidget(covariant TsaiLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status != oldWidget.status ||
        widget.period != oldWidget.period) {
      _hoverIndex = null;
      _holdIndex = null;
      _stickyIndex = null;
      widget.onScrubIndexChanged?.call(null);
    }
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

  int _indexForDx(double dx) {
    if (widget.points.isEmpty) {
      return 0;
    }
    final last = widget.points.length - 1;
    final t = (dx / TsaiChartMetrics.width).clamp(0.0, 1.0);
    return (t * last).round();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final periods = TsaiChartPeriod.values;
    return Semantics(
      label: widget.semanticLabel ?? 'Line chart',
      child: TsaiChartFrame(
        child: SizedBox(
          key: const ValueKey<String>('tsai-line-chart'),
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
                    _hoverIndex = _indexForDx(dx);
                  }),
                  onHoverEnd: () => setState(() => _hoverIndex = null),
                  onHoldDx: (dx) => setState(() {
                    _holdIndex = _indexForDx(dx);
                  }),
                  onHoldEnd: () {
                    setState(() {
                      _stickyIndex = _holdIndex ?? _stickyIndex;
                      _holdIndex = null;
                    });
                    _notifyScrub();
                  },
                  child: AnimatedBuilder(
                    animation: _shimmer,
                    builder: (context, child) => CustomPaint(
                      painter: _LineChartPainter(
                        tokens: tokens,
                        points: widget.points,
                        status: widget.status,
                        scrubIndex: _scrubIndex,
                        showGrid: widget.showGrid,
                        showBaseline: widget.showBaseline,
                        showAxisY: widget.showAxisY,
                        showAxisX: widget.showAxisX,
                        showArea: widget.showArea,
                        showDot: widget.showDot && _scrubIndex == null,
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
                  anchorX: tsaiLinePlotOffsets(
                    widget.points.map((point) => point.value).toList(),
                    const Size(TsaiChartMetrics.width, TsaiChartMetrics.height),
                  )[_scrubIndex!].dx,
                  maxWidth: TsaiChartMetrics.width,
                ),
              if (widget.showTabs)
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

class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({
    required this.tokens,
    required this.points,
    required this.status,
    required this.scrubIndex,
    required this.showGrid,
    required this.showBaseline,
    required this.showAxisY,
    required this.showAxisX,
    required this.showArea,
    required this.showDot,
    required this.shimmer,
  });

  final TsaiThemeTokens tokens;
  final List<TsaiChartPoint> points;
  final TsaiChartStatus status;
  final int? scrubIndex;
  final bool showGrid;
  final bool showBaseline;
  final bool showAxisY;
  final bool showAxisX;
  final bool showArea;
  final bool showDot;
  final double shimmer;

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) {
      final paint = Paint()
        ..color = tokens.colors.borderSubtle
        ..strokeWidth = tokens.borders.hairline;
      for (final y in [109.0, 136.0, 164.0]) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
    if (showBaseline) {
      final paint = Paint()
        ..color = tokens.colors.borderSubtle
        ..strokeWidth = tokens.borders.hairline;
      canvas.drawLine(
        const Offset(0, TsaiChartMetrics.linePlotBottom),
        Offset(size.width, TsaiChartMetrics.linePlotBottom),
        paint,
      );
    }

    if (status == TsaiChartStatus.empty || status == TsaiChartStatus.error) {
      return;
    }

    final values = [
      if (points.isEmpty)
        ...tsaiChartLoadingSilhouette
      else
        for (final point in points) point.value,
    ];
    final offsets = tsaiLinePlotOffsets(values, size);
    final linePath = tsaiSmoothLinePath(offsets);
    final areaPath = Path.from(linePath)
      ..lineTo(offsets.last.dx, TsaiChartMetrics.linePlotBottom)
      ..lineTo(offsets.first.dx, TsaiChartMetrics.linePlotBottom)
      ..close();

    if (status == TsaiChartStatus.loading) {
      canvas.drawPath(
        areaPath,
        Paint()
          ..shader = TsaiChartChrome.loadingAreaGradient.createShader(
            Rect.fromLTWH(
              0,
              TsaiChartMetrics.plotTop,
              size.width,
              TsaiChartMetrics.linePlotBottom - TsaiChartMetrics.plotTop,
            ),
          ),
      );
      canvas.drawPath(
        linePath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round
          ..color = tokens.colors.surfaceSkeleton,
      );
      final offset = -3 + shimmer * 6;
      canvas.saveLayer(Offset.zero & size, Paint());
      canvas.drawPath(areaPath, Paint()..color = const Color(0x338C8FA6));
      canvas.drawPath(
        linePath,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = const Color(0x338C8FA6),
      );
      canvas.drawRect(
        Offset.zero & size,
        Paint()
          ..blendMode = BlendMode.srcATop
          ..shader = LinearGradient(
            begin: Alignment(offset - 1, -0.2),
            end: Alignment(offset + 1, 0.2),
            colors: const [
              Color(0x008C8FA6),
              Color(0x338C8FA6),
              Color(0x008C8FA6),
            ],
          ).createShader(Offset.zero & size),
      );
      canvas.restore();
      return;
    }

    if (showArea) {
      canvas.drawPath(
        areaPath,
        Paint()
          ..shader = TsaiChartChrome.chartAreaGradient.createShader(
            Rect.fromLTRB(
              0,
              offsets.map((o) => o.dy).reduce((a, b) => a < b ? a : b),
              size.width,
              TsaiChartMetrics.linePlotBottom,
            ),
          ),
      );
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round
        ..color = tokens.colors.actionPrimary,
    );

    if (scrubIndex != null) {
      final point = offsets[scrubIndex!];
      final guide = Paint()
        ..color = tokens.colors.borderGuide
        ..strokeWidth = 1;
      tsaiDrawDashedLine(
        canvas,
        Offset(point.dx, TsaiChartMetrics.tooltipZoneHeight),
        Offset(point.dx, TsaiChartMetrics.linePlotBottom),
        guide,
      );
      tsaiDrawDashedLine(
        canvas,
        Offset(0, point.dy),
        Offset(size.width, point.dy),
        guide,
      );
      _drawDot(canvas, point);
    } else if (showDot) {
      _drawDot(canvas, offsets.last);
    }

    if (showAxisY) {
      final painter = TextPainter(textDirection: TextDirection.ltr);
      painter
        ..text = TextSpan(
          text: values.reduce((a, b) => a > b ? a : b).round().toString(),
          style: tokens.typography.monoCaptionExtraSmall.copyWith(
            color: tokens.colors.contentTertiary,
          ),
        )
        ..layout();
      painter.paint(canvas, const Offset(0, 95));
    }
    if (showAxisX && points.isNotEmpty) {
      final painter = TextPainter(textDirection: TextDirection.ltr);
      painter
        ..text = TextSpan(
          text: points.first.axisLabel,
          style: tokens.typography.captionExtraSmallRegular.copyWith(
            color: tokens.colors.contentTertiary,
          ),
        )
        ..layout();
      painter.paint(canvas, const Offset(0, 218));
    }
  }

  void _drawDot(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 10, Paint()..color = tokens.colors.accentHalo);
    canvas.drawCircle(center, 4, Paint()..color = tokens.colors.iconBright);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.status != status ||
      oldDelegate.scrubIndex != scrubIndex ||
      oldDelegate.showGrid != showGrid ||
      oldDelegate.showBaseline != showBaseline ||
      oldDelegate.showAxisY != showAxisY ||
      oldDelegate.showAxisX != showAxisX ||
      oldDelegate.showArea != showArea ||
      oldDelegate.showDot != showDot ||
      oldDelegate.shimmer != shimmer ||
      oldDelegate.tokens != tokens;
}
