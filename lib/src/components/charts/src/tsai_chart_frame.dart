import 'package:flutter/material.dart';

import '../tsai_chart_types.dart';

/// Scales the Penpot chart into a narrower parent without clipping halos.
class TsaiChartFrame extends StatelessWidget {
  /// Creates a fitting frame around a fixed-size chart surface.
  const TsaiChartFrame({required this.child, super.key});

  /// Chart painted at the Penpot 294×256 measure.
  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      const designWidth =
          TsaiChartMetrics.width + TsaiChartMetrics.overflow * 2;
      const designHeight =
          TsaiChartMetrics.height + TsaiChartMetrics.overflow * 2;
      final maxWidth = constraints.maxWidth;
      final width = !maxWidth.isFinite || maxWidth >= designWidth
          ? designWidth
          : maxWidth;
      if (width <= 0) {
        return const SizedBox.shrink();
      }
      return SizedBox(
        width: width,
        height: designHeight * (width / designWidth),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(TsaiChartMetrics.overflow),
            child: SizedBox(
              width: TsaiChartMetrics.width,
              height: TsaiChartMetrics.height,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}
