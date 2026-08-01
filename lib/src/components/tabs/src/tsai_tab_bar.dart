part of '../tsai_tabs.dart';

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
    final innerRadius = tokens.radii.innerMedium;

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
