import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import 'tsai_chart_types.dart';

/// A single Mini Tab segment.
class TsaiMiniTab extends StatelessWidget {
  /// Creates a Mini Tab.
  const TsaiMiniTab({
    required this.label,
    required this.selected,
    super.key,
    this.onPressed,
  });

  /// Visible label.
  final String label;

  /// Whether this segment is the active period.
  final bool selected;

  /// Called when the segment is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onPressed,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          borderRadius: BorderRadius.circular(tokens.radii.small),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected
                  ? tokens.colors.surfaceAccent
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(tokens.radii.small),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spacing.space12,
                ),
                child: Text(
                  label,
                  style: tokens.typography.badgeLabel.copyWith(
                    color: selected
                        ? tokens.colors.contentPrimary
                        : tokens.colors.contentSecondary,
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

/// Segmented period selector matching the Penpot Mini Tabs component.
class TsaiMiniTabs extends StatelessWidget {
  /// Creates Mini Tabs. Unused trailing labels can be omitted; remaining
  /// segments share the 294-pixel width equally.
  const TsaiMiniTabs({
    required this.labels,
    required this.selectedIndex,
    super.key,
    this.onChanged,
    this.width = TsaiChartMetrics.width,
  });

  /// Segment labels in visual order.
  final List<String> labels;

  /// Selected segment index.
  final int selectedIndex;

  /// Called with the tapped index.
  final ValueChanged<int>? onChanged;

  /// Track width. Defaults to the Penpot 294-pixel measure.
  final double width;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      key: const ValueKey<String>('tsai-mini-tabs'),
      width: width,
      height: TsaiChartMetrics.tabsHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.colors.surface,
          borderRadius: BorderRadius.circular(tokens.radii.innerMedium),
          border: Border.all(
            color: tokens.colors.borderSubtle,
            width: tokens.borders.hairline,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing.space2),
          child: Row(
            children: [
              for (var index = 0; index < labels.length; index++)
                Expanded(
                  child: SizedBox(
                    height: 24,
                    child: TsaiMiniTab(
                      label: labels[index],
                      selected: index == selectedIndex,
                      onPressed: onChanged == null
                          ? null
                          : () => onChanged!(index),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
