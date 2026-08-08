part of '../tsai_top_bar.dart';

/// A scroll-owning page with a pinned glass app bar and search field.
///
/// The 112-pixel header overlays [body]. An initial 120-pixel document inset
/// keeps content below the header at rest, then lets it scroll beneath the
/// glass surface. The widget does not add a system [SafeArea].
class PageWithSearchTopBar extends StatefulWidget {
  /// Creates a page with pinned app-bar and search chrome.
  const PageWithSearchTopBar({
    required this.title,
    required this.search,
    required this.body,
    super.key,
    this.leading = const [],
    this.trailing = const [],
    this.controller,
    this.physics,
  });

  /// Centered app-bar title.
  final String title;

  /// Search field displayed below the app bar.
  final TsaiSearchInput search;

  /// Scrollable document content.
  final Widget body;

  /// Widgets placed at the app bar's directional start.
  final List<Widget> leading;

  /// Widgets placed at the app bar's directional end.
  final List<Widget> trailing;

  /// Optional caller-owned scroll controller.
  final ScrollController? controller;

  /// Optional physics for the owned scroll view.
  final ScrollPhysics? physics;

  @override
  State<PageWithSearchTopBar> createState() => _PageWithSearchTopBarState();
}

class _PageWithSearchTopBarState extends State<PageWithSearchTopBar> {
  ScrollController? _internalController;

  ScrollController get _controller =>
      widget.controller ?? (_internalController ??= ScrollController());

  @override
  void didUpdateWidget(covariant PageWithSearchTopBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _internalController?.dispose();
      _internalController = null;
    }
  }

  @override
  void dispose() {
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return ColoredBox(
      color: tokens.colors.canvas,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            key: const ValueKey<String>('page-with-search-top-bar-scrollable'),
            controller: _controller,
            physics: widget.physics,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [const SizedBox(height: 120), widget.body],
            ),
          ),
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: ClipRect(
              child: BackdropFilter(
                key: const ValueKey<String>('page-with-search-top-bar-filter'),
                filter: ImageFilter.blur(
                  sigmaX: tokens.effects.glassBlur,
                  sigmaY: tokens.effects.glassBlur,
                ),
                child: ColoredBox(
                  key: const ValueKey<String>(
                    'page-with-search-top-bar-background',
                  ),
                  color: tokens.colors.canvasGlass,
                  child: SizedBox(
                    height: 112,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PageTopBar._(
                          showBackground: false,
                          leading: widget.leading,
                          title: widget.title,
                          trailing: widget.trailing,
                        ),
                        SizedBox(height: tokens.spacing.space8),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: tokens.spacing.space16,
                          ),
                          child: widget.search,
                        ),
                        SizedBox(height: tokens.spacing.space8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
