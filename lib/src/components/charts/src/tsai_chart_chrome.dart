import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../../foundation/semantic/tsai_theme_tokens.dart';
import '../../../icons/tsai_icon.dart';
import '../../link/tsai_link.dart';
import '../../typography/tsai_text.dart';
import '../tsai_chart_types.dart';

/// Empty, error, tooltip, and shimmer pieces shared by Tsai charts.
abstract final class TsaiChartChrome {
  /// Area fill under a default trend line.
  static const chartAreaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x476366F1), Color(0x006366F1)],
  );

  /// Area fill under a loading silhouette.
  static const loadingAreaGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0x338C8FA6), Color(0x008C8FA6)],
  );

  /// Vertical shimmer overlay used by loading bars.
  static const loadingBarShimmer = LinearGradient(
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
