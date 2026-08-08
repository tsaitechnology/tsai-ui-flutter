import 'dart:ui';

import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A decorative, theme-aware blurred accent glow for page backgrounds.
class TsaiGlow extends StatelessWidget {
  /// Creates a Tsai background glow.
  const TsaiGlow({super.key, this.diameter = 480, this.blurRadius = 170})
    : assert(diameter > 0),
      assert(blurRadius >= 0);

  /// Diameter of the circular color source before blur.
  final double diameter;

  /// Gaussian blur sigma applied to the color source.
  final double blurRadius;

  @override
  Widget build(BuildContext context) {
    final color = TsaiThemeTokens.of(context).colors.accentGlow;
    return ExcludeSemantics(
      child: IgnorePointer(
        child: RepaintBoundary(
          child: SizedBox.square(
            dimension: diameter,
            child: ImageFiltered(
              key: const ValueKey<String>('tsai-glow-filter'),
              imageFilter: ImageFilter.blur(
                sigmaX: blurRadius,
                sigmaY: blurRadius,
                tileMode: TileMode.decal,
              ),
              child: DecoratedBox(
                key: const ValueKey<String>('tsai-glow-source'),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
