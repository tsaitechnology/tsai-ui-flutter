import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';
import 'tsai_button_theme.dart';

/// Visual variants defined by the Penpot button component.
enum TsaiButtonVariant {
  /// High-emphasis filled action.
  primary,

  /// Accent-tinted filled action.
  secondary,

  /// Transparent action with a border.
  outline,

  /// Transparent action without a border.
  ghost,
}

/// Visual sizes defined by the Penpot button component.
enum TsaiButtonSize {
  /// A 40-pixel visual control with a padded touch target.
  medium,

  /// A 56-pixel visual control.
  large,
}

/// A themed action button with loading, disabled, pointer, and keyboard states.
///
/// Set [onPressed] to null to disable the button. While [isLoading] is true,
/// activation is suppressed and a 16-pixel progress indicator replaces the
/// leading icon.
class TsaiButton extends StatelessWidget {
  /// Creates a Tsai button.
  const TsaiButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = TsaiButtonVariant.primary,
    this.size = TsaiButtonSize.large,
    this.leadingIcon,
    this.isLoading = false,
    this.isExpanded = false,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.loadingSemanticLabel,
  });

  /// Visible action label.
  final String label;

  /// Called when activated, or null when disabled.
  final VoidCallback? onPressed;

  /// Visual emphasis.
  final TsaiButtonVariant variant;

  /// Visual size.
  final TsaiButtonSize size;

  /// Optional leading icon, normally a 16-pixel [TsaiIcon].
  final TsaiIcon? leadingIcon;

  /// Whether the action is in progress and cannot be activated.
  final bool isLoading;

  /// Whether the button fills the available horizontal space.
  final bool isExpanded;

  /// Whether the button requests focus when first shown.
  final bool autofocus;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Optional accessibility label that replaces descendant semantics.
  final String? semanticLabel;

  /// Optional accessibility label for the progress indicator.
  final String? loadingSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final theme = TsaiButtonTheme.of(context);
    final enabled = onPressed != null && !isLoading;
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final animationDuration = disableAnimations
        ? Duration.zero
        : tokens.motion.interaction;
    final defaults = _style(tokens, animationDuration);
    var style = _override(theme)?.merge(defaults) ?? defaults;
    if (disableAnimations) {
      style = style.copyWith(animationDuration: Duration.zero);
    }
    style = _withAnimatedBackground(style);
    final content = _ButtonContent(
      label: label,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      layoutGap: size == TsaiButtonSize.large ? tokens.spacing.space4 : 0,
      textStartMargin: tokens.spacing.space4,
      loadingSemanticLabel: loadingSemanticLabel,
      textDirection: Directionality.of(context),
    );
    final button = TextButton(
      onPressed: enabled ? onPressed : null,
      autofocus: autofocus,
      focusNode: focusNode,
      style: style,
      child: content,
    );
    final result = isExpanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
    if (semanticLabel == null) {
      return result;
    }
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel,
      excludeSemantics: true,
      child: result,
    );
  }

  ButtonStyle _style(TsaiThemeTokens tokens, Duration animationDuration) {
    final colors = tokens.colors;
    final isLarge = size == TsaiButtonSize.large;
    final height = isLarge ? 56.0 : 40.0;
    final radius = isLarge ? tokens.radii.large : tokens.radii.medium;
    final padding = EdgeInsetsDirectional.only(
      start: isLarge ? tokens.spacing.space20 : tokens.spacing.space16,
      end: isLarge ? tokens.spacing.space24 : tokens.spacing.space20,
    );
    final textStyle = isLarge
        ? tokens.typography.buttonLarge
        : tokens.typography.buttonMedium;

    return ButtonStyle(
      animationDuration: animationDuration,
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => _backgroundColor(states, colors),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => _foregroundColor(states, colors),
      ),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      shadowColor: const WidgetStatePropertyAll(Colors.transparent),
      elevation: const WidgetStatePropertyAll(0),
      textStyle: WidgetStatePropertyAll(textStyle),
      padding: WidgetStatePropertyAll(padding),
      minimumSize: WidgetStatePropertyAll(Size(0, height)),
      maximumSize: const WidgetStatePropertyAll(Size.infinite),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      alignment: Alignment.center,
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      ),
      side: WidgetStateProperty.resolveWith(
        (states) => _borderSide(states, colors, tokens.borders.hairline),
      ),
      splashFactory: NoSplash.splashFactory,
    );
  }

  ButtonStyle _withAnimatedBackground(ButtonStyle style) {
    if (style.backgroundBuilder != null) {
      return style;
    }
    final backgroundColor = style.backgroundColor;
    final shape = style.shape;
    final duration = style.animationDuration ?? Duration.zero;
    return style.copyWith(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundBuilder: (context, states, child) => _AnimatedButtonBackground(
        color: backgroundColor?.resolve(states) ?? Colors.transparent,
        shape: shape?.resolve(states) ?? const RoundedRectangleBorder(),
        duration: duration,
        child: child,
      ),
    );
  }

  Color _backgroundColor(Set<WidgetState> states, TsaiColorTokens colors) {
    if (isLoading) {
      return switch (variant) {
        TsaiButtonVariant.primary ||
        TsaiButtonVariant.secondary => colors.surfaceRaised,
        TsaiButtonVariant.outline ||
        TsaiButtonVariant.ghost => Colors.transparent,
      };
    }
    if (states.contains(WidgetState.disabled)) {
      return switch (variant) {
        TsaiButtonVariant.primary ||
        TsaiButtonVariant.secondary => colors.surfaceRaised,
        TsaiButtonVariant.outline ||
        TsaiButtonVariant.ghost => Colors.transparent,
      };
    }
    final active =
        states.contains(WidgetState.pressed) ||
        states.contains(WidgetState.hovered);
    return switch (variant) {
      TsaiButtonVariant.primary =>
        active ? colors.actionPrimaryPressed : colors.actionPrimary,
      TsaiButtonVariant.secondary =>
        active ? colors.surfaceAccentPressed : colors.surfaceAccent,
      TsaiButtonVariant.outline ||
      TsaiButtonVariant.ghost => active ? colors.surface : Colors.transparent,
    };
  }

  Color _foregroundColor(Set<WidgetState> states, TsaiColorTokens colors) {
    if (states.contains(WidgetState.disabled) && !isLoading) {
      return colors.contentTertiary;
    }
    if (isLoading) {
      return colors.contentPrimary;
    }
    return variant == TsaiButtonVariant.primary
        ? colors.contentOnActionPrimary
        : colors.contentPrimary;
  }

  BorderSide _borderSide(
    Set<WidgetState> states,
    TsaiColorTokens colors,
    double width,
  ) {
    if (states.contains(WidgetState.focused)) {
      return BorderSide(color: colors.actionPrimarySoft, width: width * 2);
    }
    if (variant == TsaiButtonVariant.outline) {
      return BorderSide(color: colors.surfaceAccent, width: width);
    }
    return BorderSide.none;
  }

  ButtonStyle? _override(TsaiButtonTheme theme) => switch (variant) {
    TsaiButtonVariant.primary => theme.primary,
    TsaiButtonVariant.secondary => theme.secondary,
    TsaiButtonVariant.outline => theme.outline,
    TsaiButtonVariant.ghost => theme.ghost,
  };
}

class _AnimatedButtonBackground extends StatelessWidget {
  const _AnimatedButtonBackground({
    required this.color,
    required this.shape,
    required this.duration,
    required this.child,
  });

  final Color color;
  final OutlinedBorder shape;
  final Duration duration;
  final Widget? child;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    key: const ValueKey<String>('tsai-button-animated-background'),
    duration: duration,
    curve: Curves.easeOut,
    decoration: ShapeDecoration(color: color, shape: shape),
    child: child,
  );
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.leadingIcon,
    required this.isLoading,
    required this.layoutGap,
    required this.textStartMargin,
    required this.loadingSemanticLabel,
    required this.textDirection,
  });

  final String label;
  final TsaiIcon? leadingIcon;
  final bool isLoading;
  final double layoutGap;
  final double textStartMargin;
  final String? loadingSemanticLabel;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    final icon = isLoading
        ? _TsaiSpinner(
            color:
                IconTheme.of(context).color ??
                DefaultTextStyle.of(context).style.color,
            semanticLabel: loadingSemanticLabel,
          )
        : leadingIcon;
    final children = <Widget>[
      if (icon != null) ...[
        IconTheme.merge(data: const IconThemeData(size: 16), child: icon),
        SizedBox(
          key: const ValueKey<String>('tsai-button-layout-gap'),
          width: layoutGap,
        ),
      ],
      Flexible(
        child: Padding(
          key: const ValueKey<String>('tsai-button-text-margin'),
          padding: EdgeInsetsDirectional.only(start: textStartMargin),
          child: Text(label, overflow: TextOverflow.ellipsis),
        ),
      ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: textDirection,
      children: children,
    );
  }
}

class _TsaiSpinner extends StatefulWidget {
  const _TsaiSpinner({required this.color, required this.semanticLabel});

  final Color? color;
  final String? semanticLabel;

  @override
  State<_TsaiSpinner> createState() => _TsaiSpinnerState();
}

class _TsaiSpinnerState extends State<_TsaiSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 850),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: widget.semanticLabel,
    child: RotationTransition(
      key: const ValueKey<String>('tsai-button-spinner'),
      turns: _controller,
      child: CustomPaint(
        size: const Size.square(16),
        painter: _SpinnerPainter(
          color: widget.color ?? const Color(0xFFFFFFFF),
        ),
      ),
    ),
  );
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    const arcSize = 12.0;
    final offset = (size.width - arcSize) / 2;
    final rect = Rect.fromLTWH(offset, offset, arcSize, arcSize);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) => color != oldDelegate.color;
}
