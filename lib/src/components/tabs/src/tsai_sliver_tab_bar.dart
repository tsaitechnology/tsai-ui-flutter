part of '../tsai_tabs.dart';

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
