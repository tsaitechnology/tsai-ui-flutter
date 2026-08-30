import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../foundation/semantic/tsai_theme_tokens.dart';
import '../../../icons/tsai_icon.dart';
import '../../link/tsai_link.dart';
import '../../typography/tsai_text.dart';
import '../tsai_chart_types.dart';

/// Penpot Loading bar heights (`loader bars`, 1W geometry) in plot pixels.
const tsaiChartLoadingBarHeights = [59.0, 93.0, 51.0, 140.0, 76.0, 42.0, 102.0];

/// Remembers the last loaded series so a later loading paint can gray it out.
final class TsaiChartSeriesMemory {
  /// Last loaded samples, or null after empty/error/first paint.
  List<TsaiChartPoint>? points;

  /// Period that [points] were laid out with.
  TsaiChartPeriod? period;

  /// Whether a previous data series can be reused as a skeleton.
  bool get hasPoints => points != null && points!.isNotEmpty;

  /// Updates memory from the current chart [status].
  void sync({
    required TsaiChartStatus status,
    required List<TsaiChartPoint> incoming,
    required TsaiChartPeriod incomingPeriod,
  }) {
    switch (status) {
      case TsaiChartStatus.data:
        if (incoming.isEmpty) {
          points = null;
          period = null;
        } else {
          points = List<TsaiChartPoint>.of(incoming);
          period = incomingPeriod;
        }
      case TsaiChartStatus.empty:
      case TsaiChartStatus.error:
        points = null;
        period = null;
      case TsaiChartStatus.loading:
        break;
    }
  }
}

/// Empty, error, tooltip, and loading-area pieces shared by Tsai charts.
abstract final class TsaiChartChrome {
  /// Area fill under a default trend line.
  static const chartAreaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x476366F1), Color(0x006366F1)],
  );

  /// Loading area from Penpot `loader area`: `#8C8FA6` at 20% → 0, vertical.
  static const loadingAreaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x338C8FA6), Color(0x008C8FA6)],
  );

  /// Empty plot: caption 20 pixels above a 2-pixel pill baseline.
  static Widget empty({required TsaiThemeTokens tokens}) => SizedBox(
    width: TsaiChartMetrics.width,
    height: TsaiChartMetrics.linePlotBottom - TsaiChartMetrics.plotTop,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TsaiTextCaption(
          'No data for this period',
          size: TsaiCaptionSize.medium,
          weight: TsaiTextWeight.regular,
          color: tokens.colors.contentTertiary,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: tokens.spacing.space20),
        DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.colors.actionPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(tokens.radii.pill),
          ),
          child: const SizedBox(width: 294, height: 2),
        ),
      ],
    ),
  );

  /// Error plot: alert icon, caption, and retry link.
  static Widget error({
    required TsaiThemeTokens tokens,
    required VoidCallback? onRetry,
  }) => SizedBox(
    width: TsaiChartMetrics.width,
    height: TsaiChartMetrics.linePlotBottom - TsaiChartMetrics.plotTop,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TsaiIcon(
          LucideIcons.triangle_alert,
          size: tokens.spacing.space16,
          color: tokens.colors.accentError,
        ),
        SizedBox(height: tokens.spacing.space8),
        TsaiTextCaption(
          "Couldn't load chart",
          size: TsaiCaptionSize.medium,
          weight: TsaiTextWeight.regular,
          color: tokens.colors.contentSecondary,
          textAlign: TextAlign.center,
        ),
        TsaiLink(label: 'Try again', onPressed: onRetry),
      ],
    ),
  );

  /// Inverted tooltip docked in the top 44-pixel zone.
  static Widget tooltip({
    required TsaiThemeTokens tokens,
    required String value,
    required String date,
    required double anchorX,
    required double maxWidth,
  }) {
    const tooltipWidth = 96.0;
    // Penpot: centered on the point/bar; flush to a side when that would overflow.
    final left = (anchorX - tooltipWidth / 2).clamp(
      0.0,
      maxWidth - tooltipWidth,
    );
    return Positioned(
      top: 0,
      left: left,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.colors.surfaceInverted,
          borderRadius: BorderRadius.circular(tokens.radii.innerMedium),
        ),
        child: SizedBox(
          width: tooltipWidth,
          height: TsaiChartMetrics.tooltipZoneHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TsaiTextMonoCaption(
                value,
                weight: TsaiTextWeight.medium,
                color: tokens.colors.contentInvertedPrimary,
                textAlign: TextAlign.center,
              ),
              TsaiTextCaption(
                date,
                size: TsaiCaptionSize.extraSmall,
                weight: TsaiTextWeight.regular,
                color: tokens.colors.contentInvertedSecondary,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Catmull-Rom path through [points].
Path tsaiSmoothLinePath(List<Offset> points) {
  final path = Path();
  if (points.isEmpty) {
    return path;
  }
  path.moveTo(points.first.dx, points.first.dy);
  if (points.length == 1) {
    return path;
  }
  for (var index = 0; index < points.length - 1; index++) {
    final previous = index == 0 ? points[index] : points[index - 1];
    final current = points[index];
    final next = points[index + 1];
    final following = index + 2 < points.length ? points[index + 2] : next;
    path.cubicTo(
      current.dx + (next.dx - previous.dx) / 6,
      current.dy + (next.dy - previous.dy) / 6,
      next.dx - (following.dx - current.dx) / 6,
      next.dy - (following.dy - current.dy) / 6,
      next.dx,
      next.dy,
    );
  }
  return path;
}

/// Penpot Loading line (`loader` path) in chart-local coordinates.
Path tsaiChartLoadingLinePath() {
  const originX = 130.0;
  const originY = 556.0;
  final path = Path()..moveTo(130 - originX, 721.5999755859375 - originY);
  void cubic(
    double c1x,
    double c1y,
    double c2x,
    double c2y,
    double x,
    double y,
  ) {
    path.cubicTo(
      c1x - originX,
      c1y - originY,
      c2x - originX,
      c2y - originY,
      x - originX,
      y - originY,
    );
  }

  cubic(
    134.1649932861328,
    719.6959838867188,
    151.07000732421875,
    711.72998046875,
    159.39999389648438,
    708.1599731445312,
  );
  cubic(
    167.72999572753906,
    704.5900268554688,
    180.47000122070312,
    696.4000244140625,
    188.8000030517578,
    696.4000244140625,
  );
  cubic(
    197.1300048828125,
    696.4000244140625,
    209.8699951171875,
    705.0659790039062,
    218.1999969482422,
    708.1599731445312,
  );
  cubic(
    226.52999877929688,
    711.2540283203125,
    239.27000427246094,
    719.6680297851562,
    247.60000610351562,
    718.239990234375,
  );
  cubic(
    255.92999267578125,
    716.81201171875,
    268.6700134277344,
    704.2680053710938,
    277,
    698.0800170898438,
  );
  cubic(
    285.3299865722656,
    691.8920288085938,
    298.07000732421875,
    675.9879760742188,
    306.3999938964844,
    674.5599975585938,
  );
  cubic(
    314.7300109863281,
    673.1320190429688,
    327.4700012207031,
    688.9520263671875,
    335.79998779296875,
    688,
  );
  cubic(
    344.1300048828125,
    687.0479736328125,
    356.8699951171875,
    674.0280151367188,
    365.20001220703125,
    667.8400268554688,
  );
  cubic(
    373.5299987792969,
    661.6519775390625,
    386.2699890136719,
    650.9840087890625,
    394.6000061035156,
    644.3200073242188,
  );
  cubic(
    402.92999267578125,
    637.656005859375,
    419.8349914550781,
    624.1320190429688,
    424,
    620.7999877929688,
  );
  return path;
}

/// Maps series values into line-chart plot coordinates.
List<Offset> tsaiLinePlotOffsets(List<double> values, Size size) {
  if (values.isEmpty) {
    return const [];
  }
  final minValue = values.reduce((a, b) => a < b ? a : b);
  final maxValue = values.reduce((a, b) => a > b ? a : b);
  final span = (maxValue - minValue).abs() < 0.0001 ? 1.0 : maxValue - minValue;
  final top =
      TsaiChartMetrics.tooltipZoneHeight + TsaiChartMetrics.peakClearance;
  final bottom = TsaiChartMetrics.linePlotBottom;
  final last = values.length - 1;
  return [
    for (var index = 0; index < values.length; index++)
      Offset(
        last == 0 ? size.width : index * size.width / last,
        bottom - ((values[index] - minValue) / span) * (bottom - top),
      ),
  ];
}

/// Loading area + 3-pixel skeleton stroke from Penpot `loader` / `loader area`.
void tsaiPaintLoadingLine(
  Canvas canvas,
  Size size,
  Path linePath,
  Color skeleton,
) {
  final minY = linePath.getBounds().top;
  final areaPath = Path.from(linePath)
    ..lineTo(linePath.getBounds().right, TsaiChartMetrics.linePlotBottom)
    ..lineTo(linePath.getBounds().left, TsaiChartMetrics.linePlotBottom)
    ..close();
  canvas.drawPath(
    areaPath,
    Paint()
      ..shader = TsaiChartChrome.loadingAreaGradient.createShader(
        Rect.fromLTRB(0, minY, size.width, TsaiChartMetrics.linePlotBottom),
      ),
  );
  canvas.drawPath(
    linePath,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..color = skeleton,
  );
}

/// Draws a 3-pixel dash / 3-pixel gap segment.
void tsaiDrawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
  const dash = 3.0;
  const gap = 3.0;
  final delta = end - start;
  final distance = delta.distance;
  if (distance == 0) {
    return;
  }
  final direction = delta / distance;
  var consumed = 0.0;
  var drawing = true;
  while (consumed < distance) {
    final step = drawing ? dash : gap;
    final next = (consumed + step).clamp(0.0, distance);
    if (drawing) {
      canvas.drawLine(
        start + direction * consumed,
        start + direction * next,
        paint,
      );
    }
    consumed = next;
    drawing = !drawing;
  }
}
