import 'package:flutter/material.dart';

/// A 32-pixel interaction target with a centered, configurable-size icon.
class HitIcon extends StatelessWidget {
  /// Creates a fixed-size icon target.
  const HitIcon({
    required this.icon,
    super.key,
    this.iconSize = 24,
    this.onPressed,
    this.semanticLabel,
  }) : assert(iconSize > 0 && iconSize <= 32);

  /// The icon displayed in the center of the target.
  final Widget icon;

  /// The square icon extent inside the fixed 32-pixel target.
  final double iconSize;

  /// Called when the target is activated.
  ///
  /// When null, the icon remains visible but is not interactive.
  final VoidCallback? onPressed;

  /// Accessibility label for an interactive target.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final content = SizedBox.square(
      dimension: 32,
      child: IconTheme.merge(
        data: IconThemeData(size: iconSize),
        child: Center(
          child: SizedBox.square(
            dimension: iconSize,
            child: FittedBox(fit: BoxFit.contain, child: icon),
          ),
        ),
      ),
    );
    if (onPressed == null) {
      return content;
    }
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: FocusableActionDetector(
        mouseCursor: SystemMouseCursors.click,
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              onPressed!();
              return null;
            },
          ),
        },
        child: GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: content,
        ),
      ),
    );
  }
}
