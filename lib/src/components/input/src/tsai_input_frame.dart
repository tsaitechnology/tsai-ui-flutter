part of '../tsai_input.dart';

class _TsaiInputFrame extends StatelessWidget {
  const _TsaiInputFrame({
    required this.content,
    required this.actions,
    required this.focused,
    required this.hovered,
    required this.enabled,
    required this.hasError,
    required this.description,
    required this.errorText,
    required this.onFieldTap,
    this.onFieldPointerDown,
  });

  final Widget content;
  final List<Widget> actions;
  final bool focused;
  final bool hovered;
  final bool enabled;
  final bool hasError;
  final String? description;
  final String? errorText;
  final VoidCallback? onFieldTap;
  final PointerDownEventListener? onFieldPointerDown;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final borderColor = hasError
        ? colors.accentError
        : focused
        ? colors.actionPrimarySoft
        : hovered && enabled
        ? colors.borderStrong
        : colors.borderSubtle;
    return Column(
      key: const ValueKey<String>('tsai-input-layout'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Listener(
          behavior: HitTestBehavior.opaque,
          onPointerDown: onFieldPointerDown,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onFieldTap,
            child: AnimatedContainer(
              key: const ValueKey<String>('tsai-input-field'),
              duration: _duration(context, tokens),
              height: 56,
              padding: EdgeInsetsDirectional.only(
                start: math.max(
                  0,
                  tokens.spacing.space16 - tokens.borders.hairline,
                ),
                end: math.max(
                  0,
                  tokens.spacing.space8 - tokens.borders.hairline,
                ),
              ),
              decoration: BoxDecoration(
                color: enabled ? colors.surface : colors.surfaceRaised,
                borderRadius: BorderRadius.circular(tokens.radii.medium),
                border: Border.all(
                  color: borderColor,
                  width: tokens.borders.hairline,
                ),
              ),
              child: Row(
                children: [
                  Expanded(child: content),
                  if (actions.isNotEmpty)
                    Row(
                      key: const ValueKey<String>('tsai-input-actions'),
                      mainAxisSize: MainAxisSize.min,
                      children: actions,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (description != null || errorText != null) ...[
          SizedBox(height: tokens.spacing.space4),
          Padding(
            padding: EdgeInsetsDirectional.only(start: tokens.spacing.space4),
            child: Text(
              errorText ?? description!,
              key: const ValueKey<String>('tsai-input-description'),
              style: tokens.typography.captionMediumRegular.copyWith(
                color: errorText == null
                    ? colors.contentSecondary
                    : colors.accentError,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AnimatedInputContent extends StatelessWidget {
  const _AnimatedInputContent({
    required this.placeholder,
    required this.placeholderVisible,
    required this.floating,
    required this.labelColor,
    required this.child,
  });

  final String? placeholder;
  final bool placeholderVisible;
  final bool floating;
  final Color labelColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final duration = _placeholderDuration(context, tokens);
    return Stack(
      key: const ValueKey<String>('tsai-input-content'),
      fit: StackFit.expand,
      children: [
        AnimatedAlign(
          key: const ValueKey<String>('tsai-input-value-position'),
          duration: duration,
          curve: tokens.motion.transitionCurve,
          alignment: floating
              ? const AlignmentDirectional(-1, 0.45)
              : AlignmentDirectional.centerStart,
          child: child,
        ),
        if (placeholder != null)
          IgnorePointer(
            child: AnimatedOpacity(
              duration: duration,
              opacity: placeholderVisible ? 1 : 0,
              child: AnimatedAlign(
                key: const ValueKey<String>('tsai-input-placeholder-position'),
                duration: duration,
                curve: tokens.motion.transitionCurve,
                alignment: floating
                    ? const AlignmentDirectional(-1, -0.45)
                    : AlignmentDirectional.centerStart,
                child: AnimatedDefaultTextStyle(
                  key: const ValueKey<String>('tsai-input-placeholder'),
                  duration: duration,
                  curve: tokens.motion.transitionCurve,
                  style:
                      (floating
                              ? tokens.typography.captionMediumRegular
                              : tokens.typography.bodyLarge)
                          .copyWith(
                            color: floating
                                ? labelColor
                                : tokens.colors.contentTertiary,
                          ),
                  child: Text(
                    placeholder!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _InputContent extends StatelessWidget {
  const _InputContent({
    required this.label,
    required this.labelColor,
    required this.child,
  });

  final String? label;
  final Color labelColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      key: const ValueKey<String>('tsai-input-content'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.captionMediumRegular.copyWith(
              color: labelColor,
            ),
          ),
          SizedBox(height: tokens.spacing.space2),
        ],
        child,
      ],
    );
  }
}

class _InputAction extends StatelessWidget {
  const _InputAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final TsaiIcon icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = TsaiThemeTokens.of(context).colors;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      splashRadius: 16,
      icon: IconTheme.merge(
        data: IconThemeData(
          color: onPressed == null ? colors.iconTertiary : colors.iconSecondary,
        ),
        child: icon,
      ),
    );
  }
}

Duration _duration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction;

Duration _placeholderDuration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction * 1.5;

double _textWidth(BuildContext context, String value, TextStyle style) {
  return math.max(
    10,
    _paintedTextWidth(
          context,
          value.isEmpty ? '0' : value,
          style,
        ).ceilToDouble() +
        2,
  );
}

double _paintedTextWidth(BuildContext context, String value, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(text: value, style: style),
    maxLines: 1,
    textDirection: Directionality.of(context),
    textScaler: MediaQuery.textScalerOf(context),
  )..layout();
  return painter.width;
}
