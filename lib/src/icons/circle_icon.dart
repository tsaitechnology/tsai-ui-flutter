import 'package:flutter/material.dart';

import '../foundation/semantic/tsai_theme_tokens.dart';

/// A 20-pixel icon centered on the token-backed 40-pixel circular surface.
class CircleIcon extends StatelessWidget {
  /// Creates a fixed-size circular icon.
  const CircleIcon({required this.icon, super.key, this.semanticLabel});

  /// The icon displayed in the center of the circle.
  final Widget icon;

  /// Optional accessibility label for a meaningful standalone icon.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final circle = SizedBox.square(
      dimension: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.colors.surfaceRaised,
          borderRadius: BorderRadius.circular(tokens.radii.pill),
        ),
        child: IconTheme.merge(
          data: IconThemeData(size: 20, color: tokens.colors.iconSecondary),
          child: Center(
            child: SizedBox.square(
              dimension: 20,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  tokens.colors.iconSecondary,
                  BlendMode.srcIn,
                ),
                child: FittedBox(fit: BoxFit.contain, child: icon),
              ),
            ),
          ),
        ),
      ),
    );
    if (semanticLabel == null) {
      return ExcludeSemantics(child: circle);
    }
    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: circle,
    );
  }
}
