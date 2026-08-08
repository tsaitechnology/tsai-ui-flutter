part of '../tsai_top_bar.dart';

/// A compact icon action for [PageTopBar].
class PageTopBarAction extends StatelessWidget {
  /// Creates a page top-bar action.
  const PageTopBarAction({
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    super.key,
  });

  /// The 24-pixel action icon.
  final TsaiIcon icon;

  /// Called when activated, or null when disabled.
  final VoidCallback? onPressed;

  /// Accessibility label and pointer tooltip.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Tooltip(
      message: semanticLabel,
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: semanticLabel,
        excludeSemantics: true,
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
            hoverColor: tokens.colors.surface,
            highlightColor: tokens.colors.surface,
            child: SizedBox.square(
              dimension: tokens.spacing.space32,
              child: Center(
                child: IconTheme.merge(
                  data: IconThemeData(color: tokens.colors.iconPrimary),
                  child: icon,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A 56-pixel glass secondary-page top bar with a centered title.
///
/// [leading], [title], and [trailing] occupy symmetric one-two-one tracks, so
/// edge content remains bounded and the title stays centered. This widget
/// fills the available width and does not add a system [SafeArea].
class PageTopBar extends StatelessWidget {
  /// Creates a page top bar.
  const PageTopBar({
    super.key,
    this.leading = const [],
    this.title,
    this.trailing = const [],
  }) : _showBackground = true;

  const PageTopBar._({
    required this._showBackground,
    this.leading = const [],
    this.title,
    this.trailing = const [],
  });

  /// Widgets placed at the directional start.
  final List<Widget> leading;

  /// Optional centered title text.
  final String? title;

  /// Widgets placed at the directional end.
  final List<Widget> trailing;

  final bool _showBackground;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ClipRect(
      child: BackdropFilter(
        enabled: _showBackground,
        filter: ImageFilter.blur(
          sigmaX: tokens.effects.glassBlur,
          sigmaY: tokens.effects.glassBlur,
        ),
        child: ColoredBox(
          key: const ValueKey<String>('page-top-bar-background'),
          color: _showBackground
              ? tokens.colors.canvasGlass
              : Colors.transparent,
          child: SizedBox(
            width: double.infinity,
            height: tokens.spacing.space32 + tokens.spacing.space24,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space16),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRect(
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: _BoundedSpacedRow(
                          alignment: MainAxisAlignment.start,
                          children: leading,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ClipRect(
                      child: Align(
                        child: title == null
                            ? const SizedBox.shrink()
                            : Text(
                                title!,
                                style: tokens.typography.bodyLargeMedium
                                    .copyWith(
                                      color: tokens.colors.contentPrimary,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRect(
                      child: Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: _BoundedSpacedRow(
                          alignment: MainAxisAlignment.end,
                          children: trailing,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
