import 'package:flutter/material.dart';

import '../foundation/semantic/tsai_theme_tokens.dart';

/// A 32-pixel interaction target with a centered 24-pixel icon.
class HitIcon extends StatelessWidget {
  /// Creates a fixed-size icon target.
  const HitIcon({
    required this.icon,
    super.key,
    this.onPressed,
    this.semanticLabel,
  });

  /// The icon displayed in the center of the target.
  final Widget icon;

  /// Called when the target is activated.
  ///
  /// When null, the icon remains visible but is not interactive.
  final VoidCallback? onPressed;

  /// Accessibility label for an interactive target.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final content = SizedBox.square(
      dimension: 32,
      child: IconTheme.merge(
        data: IconThemeData(size: 24, color: tokens.colors.iconPrimary),
        child: Center(
          child: SizedBox.square(
            dimension: 24,
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                tokens.colors.iconPrimary,
                BlendMode.srcIn,
              ),
              child: FittedBox(fit: BoxFit.contain, child: icon),
            ),
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
