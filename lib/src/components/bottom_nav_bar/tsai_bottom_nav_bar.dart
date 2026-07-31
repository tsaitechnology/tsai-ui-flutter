import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';

/// Immutable content for one [BottomNavBar] destination.
@immutable
final class BottomNavBarItem {
  /// Creates a bottom-navigation destination.
  const BottomNavBarItem({
    required this.icon,
    required this.label,
    this.semanticLabel,
  }) : assert(label.length > 0);

  /// Icon displayed above [label].
  final TsaiIcon icon;

  /// Visible one-line destination label.
  final String label;

  /// Optional accessibility label. Defaults to [label].
  final String? semanticLabel;
}

/// A centered glass bottom-navigation bar with one to four destinations.
///
/// Every destination keeps the Penpot 80 by 54 pixel size. The centered glass
/// pill grows from 88 to 328 pixels as destinations are added. [selectedIndex]
/// is controlled by the caller and [onSelected] fires once when a destination
/// is activated.
class BottomNavBar extends StatelessWidget {
  /// Creates a controlled bottom-navigation bar.
  const BottomNavBar({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  }) : assert(items.length > 0 && items.length <= 4),
       assert(selectedIndex >= 0 && selectedIndex < items.length);

  /// Destinations displayed in directional order.
  ///
  /// The list must contain between one and four items.
  final List<BottomNavBarItem> items;

  /// Index of the currently selected destination.
  final int selectedIndex;

  /// Called with the activated destination index.
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final itemWidth = tokens.spacing.space80;
    final itemHeight =
        tokens.spacing.space32 + tokens.spacing.space16 + tokens.spacing.space6;
    final pillPadding = tokens.spacing.space4;
    final pillWidth = itemWidth * items.length + pillPadding * 2;
    final pillHeight = itemHeight + pillPadding * 2;
    final barHeight = pillHeight + tokens.spacing.space32;
    final borderRadius = BorderRadius.circular(tokens.radii.pill);

    return DecoratedBox(
      decoration: BoxDecoration(gradient: tokens.gradients.bottomScrim),
      child: SizedBox(
        width: double.infinity,
        height: barHeight,
        child: Align(
          alignment: Alignment.topCenter,
          child: OverflowBox(
            minWidth: pillWidth,
            maxWidth: pillWidth,
            minHeight: pillHeight,
            maxHeight: pillHeight,
            alignment: Alignment.topCenter,
            child: SizedBox(
              key: const ValueKey<String>('bottom-nav-bar-pill'),
              width: pillWidth,
              height: pillHeight,
              child: ClipRRect(
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
                    child: Padding(
                      padding: EdgeInsets.all(pillPadding),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var index = 0; index < items.length; index++)
                            _BottomNavBarButton(
                              item: items[index],
                              selected: index == selectedIndex,
                              width: itemWidth,
                              height: itemHeight,
                              onPressed: () => onSelected(index),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavBarButton extends StatefulWidget {
  const _BottomNavBarButton({
    required this.item,
    required this.selected,
    required this.width,
    required this.height,
    required this.onPressed,
  });

  final BottomNavBarItem item;
  final bool selected;
  final double width;
  final double height;
  final VoidCallback onPressed;

  @override
  State<_BottomNavBarButton> createState() => _BottomNavBarButtonState();
}

class _BottomNavBarButtonState extends State<_BottomNavBarButton> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final borderRadius = BorderRadius.circular(tokens.radii.pill);
    final foreground = widget.selected
        ? tokens.colors.iconBright
        : tokens.colors.iconSecondary;
    final background = switch ((widget.selected, _pressed)) {
      (true, _) || (_, true) => tokens.colors.surfaceAccentGlass,
      _ => Colors.transparent,
    };
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : tokens.motion.interaction;
    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.item.semanticLabel ?? widget.item.label,
      excludeSemantics: true,
      child: SizedBox(
        key: ValueKey<String>('bottom-nav-bar-item-${widget.item.label}'),
        width: widget.width,
        height: widget.height,
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onPressed,
            onHighlightChanged: (value) => setState(() => _pressed = value),
            borderRadius: borderRadius,
            splashFactory: NoSplash.splashFactory,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: AnimatedContainer(
              key: ValueKey<String>(
                'bottom-nav-bar-item-background-${widget.item.label}',
              ),
              duration: duration,
              curve: tokens.motion.interactionCurve,
              color: background,
              child: Padding(
                padding: EdgeInsets.only(
                  top: tokens.spacing.space8,
                  bottom: tokens.spacing.space6,
                ),
                child: Column(
                  children: [
                    SizedBox.square(
                      dimension: tokens.spacing.space20,
                      child: FittedBox(
                        child: IconTheme.merge(
                          data: IconThemeData(color: foreground),
                          child: widget.item.icon,
                        ),
                      ),
                    ),
                    SizedBox(height: tokens.spacing.space4),
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            widget.item.label,
                            maxLines: 1,
                            style: tokens.typography.captionMedium.copyWith(
                              color: widget.selected
                                  ? tokens.colors.contentAccent
                                  : tokens.colors.contentSecondary,
                            ),
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
      ),
    );
  }
}
