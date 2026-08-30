part of '../tsai_textarea.dart';

class _TsaiTextareaField extends StatelessWidget {
  const _TsaiTextareaField({
    required this.content,
    required this.focused,
    required this.hovered,
    required this.enabled,
    required this.hasError,
    required this.height,
    required this.onFieldTap,
  });

  final Widget content;
  final bool focused;
  final bool hovered;
  final bool enabled;
  final bool hasError;
  final double height;
  final VoidCallback? onFieldTap;

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
    final inset = math.max(
      0.0,
      tokens.spacing.space16 - tokens.borders.hairline,
    );
    final vertical = math.max(
      0.0,
      tokens.spacing.space12 - tokens.borders.hairline,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onFieldTap,
      child: AnimatedContainer(
        key: const ValueKey<String>('tsai-textarea-field'),
        duration: _textareaDuration(context, tokens),
        height: height,
        width: double.infinity,
        padding: EdgeInsetsDirectional.fromSTEB(
          inset,
          vertical,
          inset,
          vertical,
        ),
        decoration: BoxDecoration(
          color: enabled ? colors.surface : colors.surfaceRaised,
          borderRadius: BorderRadius.circular(tokens.radii.medium),
          border: Border.all(
            color: borderColor,
            width: tokens.borders.hairline,
          ),
        ),
        child: SizedBox.expand(child: content),
      ),
    );
  }
}

class _TsaiTextareaContent extends StatelessWidget {
  const _TsaiTextareaContent({
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
    final duration = _textareaPlaceholderDuration(context, tokens);
    return Stack(
      key: const ValueKey<String>('tsai-textarea-content'),
      fit: StackFit.expand,
      children: [
        Positioned.fill(top: floating ? 19 : 0, child: child),
        if (placeholder != null)
          IgnorePointer(
            child: AnimatedOpacity(
              duration: duration,
              opacity: placeholderVisible ? 1 : 0,
              child: AnimatedDefaultTextStyle(
                key: const ValueKey<String>('tsai-textarea-placeholder'),
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
      ],
    );
  }
}

Duration _textareaDuration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction;

Duration _textareaPlaceholderDuration(
  BuildContext context,
  TsaiThemeTokens tokens,
) => MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction * 1.5;
