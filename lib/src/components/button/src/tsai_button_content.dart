part of '../tsai_button.dart';

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
    curve: TsaiThemeTokens.of(context).motion.interactionCurve,
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
                DefaultTextStyle.of(context).style.color ??
                TsaiThemeTokens.of(context).colors.contentPrimary,
            duration: TsaiThemeTokens.of(context).motion.progressIndicator,
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
