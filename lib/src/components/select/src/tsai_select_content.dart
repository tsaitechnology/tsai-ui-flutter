part of '../tsai_select.dart';

class _SelectContent<T> extends StatelessWidget {
  const _SelectContent({
    required this.placeholder,
    required this.selected,
    required this.floating,
    required this.revealSelectedValue,
    required this.enabled,
    required this.hasError,
  });

  final String? placeholder;
  final TsaiSelectOption<T>? selected;
  final bool floating;
  final bool revealSelectedValue;
  final bool enabled;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final duration = _placeholderDuration(context, tokens);
    return Stack(
      key: const ValueKey<String>('tsai-select-content'),
      fit: StackFit.expand,
      children: [
        if (placeholder != null)
          IgnorePointer(
            child: AnimatedOpacity(
              duration: duration,
              opacity: selected == null || floating ? 1 : 0,
              child: AnimatedAlign(
                key: const ValueKey<String>('tsai-select-placeholder-position'),
                duration: duration,
                curve: tokens.motion.transitionCurve,
                alignment: floating
                    ? const AlignmentDirectional(-1, -0.45)
                    : AlignmentDirectional.centerStart,
                child: AnimatedDefaultTextStyle(
                  key: const ValueKey<String>('tsai-select-placeholder'),
                  duration: duration,
                  curve: tokens.motion.transitionCurve,
                  style:
                      (floating
                              ? tokens.typography.captionMediumRegular
                              : tokens.typography.bodyLarge)
                          .copyWith(
                            color: !enabled
                                ? colors.contentTertiary
                                : hasError && floating
                                ? colors.accentError
                                : floating
                                ? colors.contentSecondary
                                : colors.contentTertiary,
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
        if (selected != null)
          AnimatedOpacity(
            key: const ValueKey<String>('tsai-select-value-opacity'),
            duration: duration,
            curve: tokens.motion.revealCurve,
            opacity: revealSelectedValue ? 1 : 0,
            child: AnimatedAlign(
              key: const ValueKey<String>('tsai-select-value-position'),
              duration: duration,
              curve: tokens.motion.transitionCurve,
              alignment: floating
                  ? const AlignmentDirectional(-1, 0.45)
                  : AlignmentDirectional.centerStart,
              child: Row(
                key: const ValueKey<String>('tsai-select-value-row'),
                children: [
                  if (selected?.icon != null) ...[
                    selected!.icon!,
                    SizedBox(width: tokens.spacing.space8),
                  ],
                  Expanded(
                    child: Text(
                      selected!.label,
                      key: const ValueKey<String>('tsai-select-value'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.typography.bodyLarge.copyWith(
                        color: enabled
                            ? colors.contentPrimary
                            : colors.contentTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SelectIconButton extends StatelessWidget {
  const _SelectIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  final String tooltip;
  final TsaiIcon icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: IconTheme.merge(
      data: IconThemeData(color: color),
      child: icon,
    ),
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
    splashRadius: 16,
  );
}

Duration _duration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction;

Duration _placeholderDuration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction * 1.5;
