import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';
import '../typography/tsai_title.dart';

/// A compact user summary for a [HomeTopBar].
///
/// When [avatarUrl] is absent, loading, or fails to load, the 32-pixel avatar
/// displays [initials]. Set [onPressed] to make the whole pill interactive.
class UserPill extends StatelessWidget {
  /// Creates a user pill.
  const UserPill({
    required this.name,
    required this.initials,
    super.key,
    this.avatarUrl,
    this.onPressed,
    this.semanticLabel,
  }) : assert(name.length > 0),
       assert(initials.length > 0);

  /// The visible user name.
  final String name;

  /// Initials used when no network image is available.
  final String initials;

  /// Optional network image URL for the avatar.
  final String? avatarUrl;

  /// Called when the pill is activated, or null for a display-only pill.
  final VoidCallback? onPressed;

  /// Optional accessibility label for an interactive pill.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final content = Container(
      height: tokens.spacing.space32 + tokens.spacing.space8,
      padding: EdgeInsetsDirectional.only(
        start: tokens.spacing.space4,
        end: tokens.spacing.space12,
      ),
      decoration: BoxDecoration(
        color: onPressed == null
            ? tokens.colors.surface
            : tokens.colors.surface.withValues(alpha: 0),
        borderRadius: BorderRadius.circular(tokens.radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UserAvatar(avatarUrl: avatarUrl, initials: initials),
          SizedBox(width: tokens.spacing.space8),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tokens.typography.bodyMediumMedium.copyWith(
                color: tokens.colors.contentPrimary,
              ),
            ),
          ),
        ],
      ),
    );
    if (onPressed == null) {
      return content;
    }
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: Material(
        color: tokens.colors.surface,
        borderRadius: BorderRadius.circular(tokens.radii.pill),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashFactory: NoSplash.splashFactory,
          hoverColor: tokens.colors.surfaceRaised,
          highlightColor: tokens.colors.surfaceRaised,
          child: content,
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.avatarUrl, required this.initials});

  final String? avatarUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final fallback = ColoredBox(
      color: tokens.colors.borderStrong,
      child: Center(
        child: Text(
          initials,
          maxLines: 1,
          overflow: TextOverflow.clip,
          textScaler: TextScaler.noScaling,
          style: tokens.typography.captionSmall.copyWith(
            color: tokens.colors.contentPrimary,
          ),
        ),
      ),
    );
    final url = avatarUrl;
    final avatar = url == null || url.isEmpty
        ? fallback
        : Image.network(
            url,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                frame == null && !wasSynchronouslyLoaded ? fallback : child,
            errorBuilder: (context, error, stackTrace) => fallback,
          );
    return ClipOval(
      child: SizedBox.square(dimension: tokens.spacing.space32, child: avatar),
    );
  }
}

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
        child: Material(
          color: tokens.colors.surface,
          borderRadius: BorderRadius.circular(tokens.radii.pill),
          clipBehavior: Clip.none,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            splashFactory: NoSplash.splashFactory,
            hoverColor: tokens.colors.surfaceRaised,
            highlightColor: tokens.colors.surfaceRaised,
            child: SizedBox.square(
              dimension: extent,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Center(
                    child: IconTheme.merge(
                      data: IconThemeData(color: tokens.colors.iconPrimary),
                      child: icon,
                    ),
                  ),
                  if (showIndicator)
                    PositionedDirectional(
                      top: tokens.spacing.space2,
                      end: tokens.spacing.space2 + tokens.borders.hairline,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A 64-pixel home-page top bar with composable edge slots.
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
    return SizedBox(
      width: double.infinity,
      height: tokens.spacing.space64,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: tokens.spacing.space16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: _SpacedRow(children: leading),
              ),
            ),
            SizedBox(width: tokens.spacing.space8),
            _SpacedRow(children: trailing),
          ],
        ),
      ),
    );
  }
}

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

/// A 56-pixel secondary-page top bar with a geometrically centered title.
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
  });

  /// Widgets placed at the directional start.
  final List<Widget> leading;

  /// Optional centered title text.
  final String? title;

  /// Widgets placed at the directional end.
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
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
                          style: tokens.typography.bodyLargeMedium.copyWith(
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
    );
  }
}

/// A page composition with a pinned [PageTopBar] and one owned scroll view.
///
/// [heading] and [body] scroll as one document. As soon as the scroll offset
/// becomes positive, the single visual [heading] moves and resizes into the top
/// bar's centered title slot. The supplied [body] must have finite intrinsic
/// height and must not contain an unbounded primary scroll view.
///
/// When [controller] is omitted, this widget creates and disposes its own
/// [ScrollController]. The top bar remains outside the scrollable and this
/// widget does not add a system [SafeArea].
class PageWithTopBar extends StatefulWidget {
  /// Creates a scroll-owning page with a top bar.
  const PageWithTopBar({
    required this.heading,
    required this.body,
    super.key,
    this.subtitle,
    this.leading = const [],
    this.trailing = const [],
    this.controller,
    this.physics,
  }) : assert(heading.length > 0);

  /// The large page heading and the collapsed top-bar title.
  final String heading;

  /// Optional supporting text below the expanded heading.
  final String? subtitle;

  /// The document content below the expanded heading.
  final Widget body;

  /// Widgets placed at the top bar's directional start.
  final List<Widget> leading;

  /// Widgets placed at the top bar's directional end.
  final List<Widget> trailing;

  /// Optional caller-owned scroll controller.
  final ScrollController? controller;

  /// Optional scroll physics for the owned scroll view.
  final ScrollPhysics? physics;

  @override
  State<PageWithTopBar> createState() => _PageWithTopBarState();
}

class _PageWithTopBarState extends State<PageWithTopBar> {
  late ScrollController _controller;
  late bool _ownsController;
  bool _showCollapsedTitle = false;
  bool _isTitleTransitioning = false;

  @override
  void initState() {
    super.initState();
    _setController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant PageWithTopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_handleScroll);
      if (_ownsController) {
        _controller.dispose();
      }
      _setController(widget.controller);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _setController(ScrollController? controller) {
    _ownsController = controller == null;
    _controller = controller ?? ScrollController();
    _showCollapsedTitle = _controller.hasClients && _controller.offset > 0;
    _controller.addListener(_handleScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _controller.hasClients) {
        _handleScroll();
      }
    });
  }

  void _handleScroll() {
    final showCollapsedTitle = _controller.offset > 0;
    if (showCollapsedTitle != _showCollapsedTitle && mounted) {
      setState(() {
        _showCollapsedTitle = showCollapsedTitle;
        _isTitleTransitioning = true;
      });
    }
  }

  void _handleTitleTransitionEnd() {
    if (_isTitleTransitioning && mounted) {
      setState(() => _isTitleTransitioning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final duration = disableAnimations
        ? Duration.zero
        : tokens.motion.transition;
    final expandedHeadingStyle = tokens.typography.headingExtraLarge.copyWith(
      color: tokens.colors.contentPrimary,
    );
    final collapsedHeadingStyle = tokens.typography.bodyLargeMedium.copyWith(
      color: tokens.colors.contentPrimary,
    );
    final expandedHeadingHeight =
        expandedHeadingStyle.fontSize! * expandedHeadingStyle.height!;
    final expandedTitleHeight =
        expandedHeadingHeight +
        (widget.subtitle == null
            ? 0
            : tokens.spacing.space4 +
                  tokens.typography.bodyMedium.fontSize! *
                      tokens.typography.bodyMedium.height!);
    final topBarHeight = tokens.spacing.space32 + tokens.spacing.space24;
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: tokens.colors.canvas,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageTopBar(leading: widget.leading, trailing: widget.trailing),
                Expanded(
                  child: SingleChildScrollView(
                    key: const ValueKey<String>('page-with-top-bar-scrollable'),
                    controller: _controller,
                    physics: widget.physics,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: tokens.spacing.space8),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: tokens.spacing.space16,
                          ),
                          child: SizedBox(
                            height: expandedTitleHeight,
                            child:
                                !_showCollapsedTitle && !_isTitleTransitioning
                                ? TsaiTitle(
                                    widget.heading,
                                    key: const ValueKey<String>(
                                      'page-with-top-bar-heading',
                                    ),
                                    subtitle: widget.subtitle,
                                  )
                                : null,
                          ),
                        ),
                        widget.body,
                      ],
                    ),
                  ),
                ),
              ],
            ),
            AnimatedPositionedDirectional(
              duration: duration,
              curve: tokens.motion.transitionCurve,
              onEnd: _handleTitleTransitionEnd,
              top: _showCollapsedTitle
                  ? 0
                  : topBarHeight + tokens.spacing.space8,
              start: _showCollapsedTitle ? 0 : tokens.spacing.space16,
              end: _showCollapsedTitle ? 0 : tokens.spacing.space16,
              height: _showCollapsedTitle
                  ? topBarHeight
                  : expandedHeadingHeight,
              child: Visibility(
                visible: _showCollapsedTitle || _isTitleTransitioning,
                child: IgnorePointer(
                  child: AnimatedAlign(
                    duration: duration,
                    curve: tokens.motion.transitionCurve,
                    alignment: _showCollapsedTitle
                        ? Alignment.center
                        : AlignmentDirectional.centerStart,
                    child: AnimatedDefaultTextStyle(
                      duration: duration,
                      curve: tokens.motion.transitionCurve,
                      style: _showCollapsedTitle
                          ? collapsedHeadingStyle
                          : expandedHeadingStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: Text(
                        widget.heading,
                        key: const ValueKey<String>(
                          'page-with-top-bar-heading',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpacedRow extends StatelessWidget {
  const _SpacedRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = TsaiThemeTokens.of(context).spacing.space8;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) SizedBox(width: gap),
          children[index],
        ],
      ],
    );
  }
}

class _BoundedSpacedRow extends StatelessWidget {
  const _BoundedSpacedRow({required this.alignment, required this.children});

  final MainAxisAlignment alignment;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = TsaiThemeTokens.of(context).spacing.space8;
    return Row(
      mainAxisAlignment: alignment,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) SizedBox(width: gap),
          Flexible(fit: FlexFit.loose, child: children[index]),
        ],
      ],
    );
  }
}
