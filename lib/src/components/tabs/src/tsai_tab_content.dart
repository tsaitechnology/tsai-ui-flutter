part of '../tsai_tabs.dart';

/// Animated content coordinated by a [TabController].
class TsaiTabContent extends StatefulWidget {
  /// Creates naturally sized tab content for a parent-owned scroll view.
  const TsaiTabContent.intrinsic({
    required this.controller,
    required this.children,
    super.key,
  }) : layout = TsaiTabContentLayout.intrinsic,
       physics = null;

  /// Creates bounded, swipeable tab content.
  const TsaiTabContent.viewport({
    required this.controller,
    required this.children,
    super.key,
    this.physics,
  }) : layout = TsaiTabContentLayout.viewport;

  /// Coordinates content selection with a matching tab bar.
  final TabController controller;

  /// Sections displayed in the same order as their tabs.
  final List<Widget> children;

  /// The vertical layout contract.
  final TsaiTabContentLayout layout;

  /// Optional swipe physics for viewport content.
  final ScrollPhysics? physics;

  @override
  State<TsaiTabContent> createState() => _TsaiTabContentState();
}

class _TsaiTabContentState extends State<TsaiTabContent> {
  late int _selectedIndex;
  int _direction = 1;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.controller.index;
    widget.controller.addListener(_handleController);
  }

  @override
  void didUpdateWidget(covariant TsaiTabContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleController);
      _selectedIndex = widget.controller.index;
      widget.controller.addListener(_handleController);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleController);
    super.dispose();
  }

  void _handleController() {
    final nextIndex = widget.controller.index;
    if (nextIndex == _selectedIndex || !mounted) {
      return;
    }
    setState(() {
      _direction = nextIndex > _selectedIndex ? 1 : -1;
      _selectedIndex = nextIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.children.isNotEmpty,
      'TsaiTabContent requires at least one child.',
    );
    assert(
      widget.controller.length == widget.children.length,
      'TabController length must match the number of content sections.',
    );

    if (widget.layout == TsaiTabContentLayout.viewport) {
      return TabBarView(
        controller: widget.controller,
        physics: widget.physics,
        children: widget.children,
      );
    }

    final tokens = TsaiThemeTokens.of(context);
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = disableAnimations
        ? Duration.zero
        : tokens.motion.transition;

    return AnimatedSize(
      duration: duration,
      curve: tokens.motion.transitionCurve,
      alignment: Alignment.topCenter,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: tokens.motion.transitionCurve,
        switchOutCurve: tokens.motion.interactionCurve,
        layoutBuilder: (currentChild, previousChildren) => Stack(
          alignment: Alignment.topCenter,
          children: [...previousChildren, ?currentChild],
        ),
        transitionBuilder: (child, animation) {
          final offset = Tween<Offset>(
            begin: Offset(0.06 * _direction, 0),
            end: Offset.zero,
          ).animate(animation);
          // Hold the incoming content transparent through the first slice of
          // the slide so it asserts itself only after the outgoing section has
          // mostly left, avoiding a muddy cross-fade.
          final opacity = CurvedAnimation(
            parent: animation,
            curve: const Interval(0.15, 1),
          );
          return FadeTransition(
            opacity: opacity,
            child: SlideTransition(position: offset, child: child),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: widget.children[_selectedIndex],
        ),
      ),
    );
  }
}
