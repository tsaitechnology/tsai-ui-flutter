import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// How a [TsaiTabBar] distributes its tabs horizontally.
enum TsaiTabBarFit {
  /// Gives every tab an equal share of the available width.
  expand,

  /// Sizes tabs to their content and scrolls the tab row when necessary.
  scrollable,
}

/// How [TsaiTabContent] participates in vertical layout.
enum TsaiTabContentLayout {
  /// Gives the selected section its natural height.
  ///
  /// The surrounding page owns scrolling in this mode.
  intrinsic,

  /// Fills bounded remaining height with a swipeable viewport.
  ///
  /// Each section normally supplies its own [ScrollView].
  viewport,
}

/// A tab label and its corresponding content section.
@immutable
final class TsaiTabSection {
  /// Creates a tab section with a composed label.
  const TsaiTabSection({required this.tab, required this.content});

  /// Creates a tab section with a text label.
  TsaiTabSection.text({required String label, required this.content})
    : tab = Text(label);

  /// The label rendered in the tab bar.
  final Widget tab;

  /// The content rendered when this section is selected.
  final Widget content;
}

/// The token-backed Tsai tab selector.
///
/// The [controller] must have the same length as [tabs].
class TsaiTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a tab selector.
  const TsaiTabBar({
    required this.controller,
    required this.tabs,
    super.key,
    this.fit = TsaiTabBarFit.expand,
    this.onTap,
    this.physics,
  });

  /// Coordinates selection with matching tab content.
  final TabController controller;

  /// Labels displayed in visual order.
  final List<Widget> tabs;

  /// How tabs consume the available horizontal space.
  final TsaiTabBarFit fit;

  /// Called after a tab is tapped.
  final ValueChanged<int>? onTap;

  /// Optional scrolling physics used when [fit] is scrollable.
  final ScrollPhysics? physics;

  /// The exact Penpot component size.
  @override
  Size get preferredSize => const Size.fromHeight(36);

  @override
  Widget build(BuildContext context) {
    assert(tabs.isNotEmpty, 'TsaiTabBar requires at least one tab.');
    assert(
      controller.length == tabs.length,
      'TabController length must match the number of tabs.',
    );

    final tokens = TsaiThemeTokens.of(context);
    final scrollable = fit == TsaiTabBarFit.scrollable;
    final innerRadius = tokens.radii.medium - tokens.spacing.space2;

    return SizedBox(
      height: preferredSize.height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.colors.surface,
          border: Border.all(
            color: tokens.colors.borderSubtle,
            width: tokens.borders.hairline,
          ),
          borderRadius: BorderRadius.circular(tokens.radii.medium),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing.space2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerRadius),
            child: TabBar(
              controller: controller,
              isScrollable: scrollable,
              tabAlignment: scrollable ? TabAlignment.start : TabAlignment.fill,
              physics: physics,
              onTap: onTap,
              indicator: BoxDecoration(
                color: tokens.colors.surfaceAccent,
                borderRadius: BorderRadius.circular(innerRadius),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerHeight: 0,
              dividerColor: Colors.transparent,
              labelColor: tokens.colors.contentPrimary,
              unselectedLabelColor: tokens.colors.contentSecondary,
              labelStyle: tokens.typography.captionMedium,
              unselectedLabelStyle: tokens.typography.captionMedium,
              labelPadding: scrollable
                  ? EdgeInsets.symmetric(horizontal: tokens.spacing.space16)
                  : EdgeInsets.zero,
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.focused) ||
                    states.contains(WidgetState.hovered)) {
                  return tokens.colors.surfaceAccent.withValues(alpha: 0.35);
                }
                return Colors.transparent;
              }),
              splashBorderRadius: BorderRadius.circular(innerRadius),
              splashFactory: NoSplash.splashFactory,
              tabs: [
                for (final tab in tabs)
                  SizedBox(
                    height: 32,
                    child: Center(
                      child: DefaultTextStyle.merge(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        child: tab,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

/// A convenient tab bar and content composition.
///
/// When [contentLayout] is [TsaiTabContentLayout.viewport], this widget must
/// receive bounded height, normally by being placed in an [Expanded].
class TsaiTabs extends StatefulWidget {
  /// Creates a complete tabs composition.
  const TsaiTabs({
    required this.sections,
    super.key,
    this.controller,
    this.initialIndex = 0,
    this.onChanged,
    this.fit = TsaiTabBarFit.expand,
    this.contentLayout = TsaiTabContentLayout.intrinsic,
    this.tabBarPhysics,
    this.contentPhysics,
  });

  /// Tab labels and matching content sections.
  final List<TsaiTabSection> sections;

  /// Optional caller-owned controller.
  ///
  /// An internal controller is created when omitted.
  final TabController? controller;

  /// Initial selection used only by an internally owned controller.
  final int initialIndex;

  /// Called when the selected index changes.
  final ValueChanged<int>? onChanged;

  /// How tabs consume horizontal space.
  final TsaiTabBarFit fit;

  /// Whether content uses natural or bounded viewport height.
  final TsaiTabContentLayout contentLayout;

  /// Optional scrolling physics for a scrollable tab bar.
  final ScrollPhysics? tabBarPhysics;

  /// Optional swipe physics for viewport content.
  final ScrollPhysics? contentPhysics;

  @override
  State<TsaiTabs> createState() => _TsaiTabsState();
}

class _TsaiTabsState extends State<TsaiTabs>
    with SingleTickerProviderStateMixin {
  TabController? _internalController;
  TabController? _activeController;
  Duration? _resolvedAnimationDuration;
  late int _lastReportedIndex;

  TabController get _controller => _activeController!;

  @override
  void initState() {
    super.initState();
    _activeController = widget.controller;
    _lastReportedIndex = widget.controller?.index ?? widget.initialIndex;
    _activeController?.addListener(_handleController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tokens = TsaiThemeTokens.of(context);
    final disableAnimations =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = disableAnimations
        ? Duration.zero
        : tokens.motion.interaction;
    if (_activeController == null) {
      _createInternalController(
        previousIndex: _lastReportedIndex,
        animationDuration: duration,
      );
      _attachInternalController();
    } else if (_internalController != null &&
        duration != _resolvedAnimationDuration) {
      final previousIndex = _controller.index;
      _controller.removeListener(_handleController);
      _internalController!.dispose();
      _createInternalController(
        previousIndex: previousIndex,
        animationDuration: duration,
      );
      _attachInternalController();
    }
    _resolvedAnimationDuration = duration;
  }

  @override
  void didUpdateWidget(covariant TsaiTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controllerChanged = oldWidget.controller != widget.controller;
    final lengthChanged = oldWidget.sections.length != widget.sections.length;
    if (!controllerChanged && !(lengthChanged && widget.controller == null)) {
      return;
    }

    final previousIndex = _activeController?.index ?? widget.initialIndex;
    _activeController?.removeListener(_handleController);
    _internalController?.dispose();
    _internalController = null;
    _activeController = widget.controller;
    if (_activeController == null) {
      _createInternalController(
        previousIndex: previousIndex,
        animationDuration:
            _resolvedAnimationDuration ?? TsaiMotionTokens.standard.interaction,
      );
      _attachInternalController();
    } else {
      _lastReportedIndex = _controller.index;
      _controller.addListener(_handleController);
    }
  }

  @override
  void dispose() {
    _activeController?.removeListener(_handleController);
    _internalController?.dispose();
    super.dispose();
  }

  void _createInternalController({
    required int previousIndex,
    required Duration animationDuration,
  }) {
    final length = widget.sections.length;
    _internalController = TabController(
      length: length,
      initialIndex: length == 0 ? 0 : previousIndex.clamp(0, length - 1),
      animationDuration: animationDuration,
      vsync: this,
    );
  }

  void _attachInternalController() {
    _activeController = _internalController;
    _lastReportedIndex = _controller.index;
    _controller.addListener(_handleController);
  }

  void _handleController() {
    final index = _controller.index;
    if (index == _lastReportedIndex) {
      return;
    }
    _lastReportedIndex = index;
    widget.onChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.sections.isNotEmpty,
      'TsaiTabs requires at least one section.',
    );
    assert(
      widget.initialIndex >= 0 && widget.initialIndex < widget.sections.length,
      'initialIndex must identify an existing section.',
    );
    assert(
      _controller.length == widget.sections.length,
      'TabController length must match the number of sections.',
    );

    final bar = TsaiTabBar(
      controller: _controller,
      tabs: [for (final section in widget.sections) section.tab],
      fit: widget.fit,
      physics: widget.tabBarPhysics,
    );
    final content = widget.contentLayout == TsaiTabContentLayout.viewport
        ? TsaiTabContent.viewport(
            controller: _controller,
            physics: widget.contentPhysics,
            children: [for (final section in widget.sections) section.content],
          )
        : TsaiTabContent.intrinsic(
            controller: _controller,
            children: [for (final section in widget.sections) section.content],
          );

    return Column(
      mainAxisSize: widget.contentLayout == TsaiTabContentLayout.intrinsic
          ? MainAxisSize.min
          : MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        bar,
        if (widget.contentLayout == TsaiTabContentLayout.viewport)
          Expanded(child: content)
        else
          content,
      ],
    );
  }
}

/// A sliver-hosted [TsaiTabBar] that can remain pinned while content scrolls.
class TsaiSliverTabBar extends StatelessWidget {
  /// Creates a sliver tab selector.
  const TsaiSliverTabBar({
    required this.controller,
    required this.tabs,
    super.key,
    this.fit = TsaiTabBarFit.expand,
    this.onTap,
    this.physics,
    this.pinned = true,
    this.floating = false,
  });

  /// Coordinates selection with matching tab content.
  final TabController controller;

  /// Labels displayed in visual order.
  final List<Widget> tabs;

  /// How tabs consume horizontal space.
  final TsaiTabBarFit fit;

  /// Called after a tab is tapped.
  final ValueChanged<int>? onTap;

  /// Optional scrolling physics used when [fit] is scrollable.
  final ScrollPhysics? physics;

  /// Whether the bar remains visible at the leading viewport edge.
  final bool pinned;

  /// Whether the bar becomes visible as soon as the user reverses scrolling.
  final bool floating;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SliverPersistentHeader(
      pinned: pinned,
      floating: floating,
      delegate: _TsaiTabBarSliverDelegate(
        backgroundColor: tokens.colors.canvas,
        child: TsaiTabBar(
          controller: controller,
          tabs: tabs,
          fit: fit,
          onTap: onTap,
          physics: physics,
        ),
      ),
    );
  }
}

class _TsaiTabBarSliverDelegate extends SliverPersistentHeaderDelegate {
  const _TsaiTabBarSliverDelegate({
    required this.backgroundColor,
    required this.child,
  });

  final Color backgroundColor;
  final Widget child;

  @override
  double get minExtent => 36;

  @override
  double get maxExtent => 36;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => ColoredBox(color: backgroundColor, child: child);

  @override
  bool shouldRebuild(covariant _TsaiTabBarSliverDelegate oldDelegate) =>
      backgroundColor != oldDelegate.backgroundColor ||
      child != oldDelegate.child;
}
