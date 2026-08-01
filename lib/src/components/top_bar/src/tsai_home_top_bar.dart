part of '../tsai_top_bar.dart';

/// A circular icon action for [HomeTopBar].
///
/// [showIndicator] adds the generic accent status dot used for unread
/// notifications and other action-level attention states.
class HomeTopBarAction extends StatelessWidget {
  /// Creates a home top-bar action.
  const HomeTopBarAction({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
    this.showIndicator = false,
  });

  /// The 24-pixel action icon.
  final TsaiIcon icon;

  /// Called when activated, or null when disabled.
  final VoidCallback? onPressed;

  /// Accessibility label and pointer tooltip.
  final String semanticLabel;

  /// Whether to show the generic accent status indicator.
  final bool showIndicator;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final extent = tokens.spacing.space32 + tokens.spacing.space8;
    final indicatorExtent = tokens.spacing.space8 + tokens.borders.hairline;
    return Tooltip(
      message: semanticLabel,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: semanticLabel,
        excludeSemantics: true,
        child: SizedBox.square(
          dimension: extent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: _HomeGlassSurface(
                  child: InkWell(
                    onTap: onPressed,
                    customBorder: const CircleBorder(),
                    splashFactory: NoSplash.splashFactory,
                    hoverColor: tokens.colors.surfaceRaised,
                    highlightColor: tokens.colors.surfaceRaised,
                    child: Center(
                      child: IconTheme.merge(
                        data: IconThemeData(color: tokens.colors.iconPrimary),
                        child: icon,
                      ),
                    ),
                  ),
                ),
              ),
              if (showIndicator)
                PositionedDirectional(
                  top: tokens.spacing.space2,
                  end: tokens.spacing.space2 + tokens.borders.hairline,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      key: const ValueKey<String>(
                        'home-top-bar-action-indicator',
                      ),
                      decoration: BoxDecoration(
                        color: tokens.colors.actionPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: SizedBox.square(dimension: indicatorExtent),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A 76-pixel home-page top bar with composable edge slots.
///
/// The widgets in [leading] and [trailing] are separated by the Penpot
/// eight-pixel action gap. This widget does not add a system [SafeArea].
class HomeTopBar extends StatelessWidget {
  /// Creates a home top bar.
  const HomeTopBar({
    super.key,
    this.leading = const [],
    this.trailing = const [],
  });

  /// Widgets placed at the directional start.
  final List<Widget> leading;

  /// Widgets placed at the directional end.
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: tokens.gradients.topScrim),
      child: SizedBox(
        width: double.infinity,
        height: tokens.spacing.space64 + tokens.spacing.space12,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            top: tokens.spacing.space12,
            start: tokens.spacing.space16,
            end: tokens.spacing.space16,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  heightFactor: 1,
                  child: _SpacedRow(children: leading),
                ),
              ),
              SizedBox(width: tokens.spacing.space8),
              _SpacedRow(children: trailing),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeGlassSurface extends StatelessWidget {
  const _HomeGlassSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final borderRadius = BorderRadius.circular(tokens.radii.pill);
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: tokens.effects.glassBlur,
          sigmaY: tokens.effects.glassBlur,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.colors.surfaceGlass,
            border: Border.all(
              color: tokens.colors.borderSubtle,
              width: tokens.borders.hairline,
            ),
            borderRadius: borderRadius,
          ),
          child: Material(type: MaterialType.transparency, child: child),
        ),
      ),
    );
  }
}
