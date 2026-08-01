part of '../tsai_top_bar.dart';

/// A page composition with a pinned [PageTopBar] and one owned scroll view.
///
/// [heading] and [body] scroll as one document. As soon as the scroll offset
/// becomes positive, the single visual [heading] moves and resizes into the top
/// bar's centered title slot. The supplied [body] must have finite intrinsic
/// height and must not contain an unbounded primary scroll view.
///
/// When [controller] is omitted, this widget creates and disposes its own
/// [ScrollController]. The top bar overlays the scrollable while a leading
/// scroll inset keeps the expanded title below it at rest. This widget does
/// not add a system [SafeArea].
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
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              key: const ValueKey<String>('page-with-top-bar-scrollable'),
              controller: _controller,
              physics: widget.physics,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topBarHeight + tokens.spacing.space8),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spacing.space16,
                    ),
                    child: SizedBox(
                      height: expandedTitleHeight,
                      child: !_showCollapsedTitle && !_isTitleTransitioning
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
            PositionedDirectional(
              top: 0,
              start: 0,
              end: 0,
              child: PageTopBar._(
                showBackground: _showCollapsedTitle,
                leading: widget.leading,
                trailing: widget.trailing,
              ),
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
                maintainState: true,
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
