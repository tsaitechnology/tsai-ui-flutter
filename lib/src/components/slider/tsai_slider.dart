import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A single-thumb slider matching the Penpot Slider.
class TsaiSlider extends StatelessWidget {
  /// Creates a slider.
  const TsaiSlider({
    required this.value,
    super.key,
    this.min = 0,
    this.max = 1,
    this.onChanged,
    this.semanticLabel,
  }) : assert(max > min);

  /// Current value in `[min, max]`.
  final double value;

  /// Inclusive lower bound.
  final double min;

  /// Inclusive upper bound.
  final double max;

  /// Called when the thumb moves. Null disables the slider.
  final ValueChanged<double>? onChanged;

  /// Optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final enabled = onChanged != null;
    final t = ((value - min) / (max - min)).clamp(0.0, 1.0);
    return Semantics(
      slider: true,
      enabled: enabled,
      value: '${(t * 100).round()}%',
      label: semanticLabel,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : 342.0;
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: enabled
                ? (details) => _update(details.localPosition.dx, width)
                : null,
            onHorizontalDragUpdate: enabled
                ? (details) => _update(details.localPosition.dx, width)
                : null,
            child: SizedBox(
              key: const ValueKey<String>('tsai-slider'),
              width: width,
              height: tokens.spacing.space24,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Center(
                    child: SizedBox(
                      height: tokens.spacing.space4,
                      width: width,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: tokens.colors.borderSubtle,
                          borderRadius: BorderRadius.circular(
                            tokens.radii.pill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        height: tokens.spacing.space4,
                        width: width * t,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: enabled
                                ? tokens.colors.actionPrimary
                                : tokens.colors.borderStrong,
                            borderRadius: BorderRadius.circular(
                              tokens.radii.pill,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: width * t - 12,
                    top: 0,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: enabled
                            ? tokens.colors.contentOnActionPrimary
                            : tokens.colors.iconTertiary,
                        boxShadow: enabled
                            ? const [
                                BoxShadow(
                                  color: Color(0x59000000),
                                  offset: Offset(0, 2),
                                  blurRadius: 8,
                                ),
                              ]
                            : const [],
                      ),
                      child: const SizedBox.square(dimension: 24),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _update(double dx, double width) {
    final next = (dx / width).clamp(0.0, 1.0);
    onChanged!(min + next * (max - min));
  }
}
