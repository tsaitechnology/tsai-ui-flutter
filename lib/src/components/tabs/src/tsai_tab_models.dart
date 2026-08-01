part of '../tsai_tabs.dart';

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
