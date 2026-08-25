import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/hit_icon.dart';
import '../../icons/tsai_icon.dart';
import '../typography/tsai_text.dart';

/// A quantity stepper matching the Penpot Stepper.
class TsaiStepper extends StatelessWidget {
  /// Creates a stepper.
  const TsaiStepper({
    required this.value,
    super.key,
    this.min = 0,
    this.max = 99,
    this.onChanged,
  }) : assert(max >= min);

  /// Current quantity.
  final int value;

  /// Inclusive lower bound. The minus control is blocked at this value.
  final int min;

  /// Inclusive upper bound. The plus control is blocked at this value.
  final int max;

  /// Called with the next value. Null disables both controls.
  final ValueChanged<int>? onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final canDecrement = onChanged != null && value > min;
    final canIncrement = onChanged != null && value < max;
    return Semantics(
      label: 'Quantity $value',
      child: DecoratedBox(
        key: const ValueKey<String>('tsai-stepper'),
        decoration: BoxDecoration(
          color: tokens.colors.surface,
          borderRadius: BorderRadius.circular(tokens.radii.pill),
          border: Border.all(
            color: tokens.colors.borderSubtle,
            width: tokens.borders.hairline,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space4),
          child: SizedBox(
            height: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepButton(
                  icon: LucideIcons.minus,
                  enabled: canDecrement,
                  semanticLabel: 'Decrease',
                  onPressed: canDecrement ? () => onChanged!(value - 1) : null,
                ),
                SizedBox(
                  width: tokens.spacing.space32,
                  child: TsaiTextMonoBody(
                    '$value',
                    size: TsaiBodySize.large,
                    color: tokens.colors.contentPrimary,
                    textAlign: TextAlign.center,
                  ),
                ),
                _StepButton(
                  icon: LucideIcons.plus,
                  enabled: canIncrement,
                  semanticLabel: 'Increase',
                  onPressed: canIncrement ? () => onChanged!(value + 1) : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.semanticLabel,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final String semanticLabel;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return HitIcon(
      iconSize: tokens.spacing.space16,
      semanticLabel: semanticLabel,
      onPressed: onPressed,
      icon: TsaiIcon(
        icon,
        size: tokens.spacing.space16,
        color: enabled ? tokens.colors.iconBright : tokens.colors.iconTertiary,
      ),
    );
  }
}
