import 'package:flutter/material.dart';

/// Long-press hold plus mouse hover for chart scrubbing.
class TsaiChartScrubListener extends StatelessWidget {
  /// Creates a scrub listener.
  const TsaiChartScrubListener({
    required this.enabled,
    required this.onHoverDx,
    required this.onHoverEnd,
    required this.onHoldDx,
    required this.onHoldEnd,
    required this.child,
    super.key,
  });

  /// When false, the child is shown without interaction.
  final bool enabled;

  /// Mouse hover local x. Does not stick after the pointer leaves.
  final ValueChanged<double> onHoverDx;

  /// Clears hover. Sticky hold selection is kept by the chart.
  final VoidCallback onHoverEnd;

  /// Long-press and subsequent move local x.
  final ValueChanged<double> onHoldDx;

  /// Finger or mouse button released after a hold. Selection stays.
  final VoidCallback onHoldEnd;

  /// Plot surface.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }
    return MouseRegion(
      onHover: (event) => onHoverDx(event.localPosition.dx),
      onExit: (_) => onHoverEnd(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressStart: (details) => onHoldDx(details.localPosition.dx),
        onLongPressMoveUpdate: (details) => onHoldDx(details.localPosition.dx),
        onLongPressEnd: (_) => onHoldEnd(),
        onLongPressCancel: onHoldEnd,
        child: child,
      ),
    );
  }
}
