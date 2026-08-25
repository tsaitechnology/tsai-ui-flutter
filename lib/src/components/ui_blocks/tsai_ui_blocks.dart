import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/circle_icon.dart';
import '../../icons/hit_icon.dart';
import '../typography/tsai_text.dart';

/// A compact section label with an optional trailing icon slot.
class TsaiSectionHeader extends StatelessWidget {
  /// Creates a section header.
  const TsaiSectionHeader({
    required this.title,
    super.key,
    this.trailingIcon,
    this.onTrailingIconPressed,
    this.trailingIconSemanticLabel,
  });

  /// Section label displayed with the medium body typography role.
  final String title;

  /// Optional icon displayed at the trailing edge.
  final Widget? trailingIcon;

  /// Called when the trailing icon is activated.
  final VoidCallback? onTrailingIconPressed;

  /// Accessibility label for the trailing icon action.
  final String? trailingIconSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final titleWidget = TsaiTextBody(
      title,
      size: TsaiBodySize.medium,
      weight: TsaiTextWeight.medium,
      color: tokens.colors.contentSecondary,
    );

    return SizedBox(
      height: 32,
      child: Row(
        children: [
          if (trailingIcon == null)
            titleWidget
          else ...[
            Expanded(child: titleWidget),
            SizedBox(width: tokens.spacing.space8),
            IconTheme.merge(
              data: IconThemeData(color: tokens.colors.iconSecondary),
              child: HitIcon(
                icon: trailingIcon!,
                iconSize: 24,
                onPressed: onTrailingIconPressed,
                semanticLabel: trailingIconSemanticLabel,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A centered empty state with an icon, explanatory copy, and optional button.
class TsaiEmptyState extends StatelessWidget {
  /// Creates an empty state.
  const TsaiEmptyState({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
    this.button,
  });

  /// Main icon displayed inside the circular surface.
  final Widget icon;

  /// Primary empty-state message.
  final String title;

  /// Supporting explanation displayed below [title].
  final String description;

  /// Optional action button displayed below the copy.
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: tokens.spacing.space32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconCircle(
            size: tokens.spacing.space64,
            iconSize: tokens.spacing.space24 + tokens.spacing.space4,
            icon: icon,
          ),
          SizedBox(height: tokens.spacing.space16),
          TsaiTextBody(
            title,
            size: TsaiBodySize.medium,
            weight: TsaiTextWeight.medium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: tokens.spacing.space4),
          TsaiTextCaption(
            description,
            size: TsaiCaptionSize.small,
            weight: TsaiTextWeight.regular,
            color: tokens.colors.contentSecondary,
            textAlign: TextAlign.center,
          ),
          if (button case final button?) ...[
            SizedBox(height: tokens.spacing.space16),
            button,
          ],
        ],
      ),
    );
  }
}

/// A composable list row with optional leading, trailing, and chevron slots.
///
/// [content] and [trailing] own their typography and internal layout. When
/// [onTap] is non-null, the row supports pointer and keyboard activation.
class TsaiListItem extends StatelessWidget {
  /// Creates a list item.
  const TsaiListItem({
    required this.content,
    super.key,
    this.icon,
    this.trailing,
    this.showChevron = false,
    this.active = false,
    this.onTap,
    this.semanticLabel,
  });

  /// Required primary content, normally a text widget or text column.
  final Widget content;

  /// Optional icon displayed inside a circular leading surface.
  final Widget? icon;

  /// Optional trailing content, such as a value or value column.
  final Widget? trailing;

  /// Whether to display the standard trailing chevron.
  final bool showChevron;

  /// Whether to display the active row background.
  final bool active;

  /// Called when the row is activated, or null for a non-interactive row.
  final VoidCallback? onTap;

  /// Optional accessibility label that replaces descendant semantics.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final row = Stack(
      clipBehavior: Clip.none,
      children: [
        if (active)
          Positioned.fill(
            left: -tokens.spacing.space8,
            right: -tokens.spacing.space8,
            child: DecoratedBox(
              key: const ValueKey<String>('tsai-list-item-active-background'),
              decoration: BoxDecoration(
                color: tokens.colors.surface,
                borderRadius: BorderRadius.circular(tokens.radii.large),
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.spacing.space8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon case final icon?) ...[
                CircleIcon(icon: icon),
                SizedBox(width: tokens.spacing.space8),
              ],
              Expanded(child: content),
              if (trailing case final trailing?) ...[
                SizedBox(width: tokens.spacing.space8),
                trailing,
              ],
              if (showChevron) ...[
                SizedBox(width: tokens.spacing.space8),
                Icon(
                  LucideIcons.chevron_right,
                  size: tokens.spacing.space20,
                  color: tokens.colors.iconSecondary,
                ),
              ],
            ],
          ),
        ),
      ],
    );
    final interactive = Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        child: row,
      ),
    );

    if (semanticLabel == null) {
      return Semantics(selected: active, child: interactive);
    }
    return Semantics(
      button: onTap != null,
      enabled: onTap != null,
      selected: active,
      label: semanticLabel,
      excludeSemantics: true,
      child: interactive,
    );
  }
}

/// A section header, list items, and an optional bottom button.
class TsaiList extends StatelessWidget {
  /// Creates a composed list block.
  const TsaiList({
    required this.title,
    required this.items,
    super.key,
    this.headerTrailingIcon,
    this.button,
  });

  /// Section label displayed above [items].
  final String title;

  /// Rows displayed in order.
  final List<TsaiListItem> items;

  /// Optional icon displayed at the trailing edge of the section header.
  final Widget? headerTrailingIcon;

  /// Optional button displayed below the final item.
  final Widget? button;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final children = <Widget>[
      TsaiSectionHeader(title: title, trailingIcon: headerTrailingIcon),
      ...items,
      ?button,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          if (index > 0) SizedBox(height: tokens.spacing.space8),
          children[index],
        ],
      ],
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.size,
    required this.iconSize,
    required this.icon,
  });

  final double size;
  final double iconSize;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.colors.surfaceRaised,
          borderRadius: BorderRadius.circular(tokens.radii.pill),
        ),
        child: IconTheme.merge(
          data: IconThemeData(
            size: iconSize,
            color: tokens.colors.iconSecondary,
          ),
          child: Center(
            child: SizedBox.square(
              dimension: iconSize,
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}
