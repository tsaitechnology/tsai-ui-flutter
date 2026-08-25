import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A row of page dots with one active pill, matching the Penpot Page Indicator.
class TsaiPageIndicator extends StatelessWidget {
  /// Creates a page indicator.
  const TsaiPageIndicator({required this.count, required this.index, super.key})
    : assert(count > 0),
      assert(index >= 0 && index < count);

  /// Number of visible dots.
  final int count;

  /// Zero-based active page.
  final int index;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Semantics(
      label: 'Page ${index + 1} of $count',
      child: Row(
        key: const ValueKey<String>('tsai-page-indicator'),
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i++) ...[
            if (i > 0) SizedBox(width: tokens.spacing.space8),
            _IndicatorDot(active: i == index),
          ],
        ],
      ),
    );
  }
}

class _IndicatorDot extends StatelessWidget {
  const _IndicatorDot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return AnimatedContainer(
      duration: tokens.motion.interaction,
      curve: tokens.motion.interactionCurve,
      width: active ? tokens.spacing.space24 : tokens.spacing.space8,
      height: tokens.spacing.space8,
      decoration: BoxDecoration(
        color: active
            ? tokens.colors.actionPrimarySoft
            : tokens.colors.borderSubtle,
        borderRadius: BorderRadius.circular(tokens.radii.pill),
      ),
    );
  }
}
