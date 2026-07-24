import 'package:flutter/material.dart';

/// A stable square adapter for icon glyphs, emoji, and custom icon widgets.
class TsaiIcon extends StatelessWidget {
  /// Creates an [IconData] icon that inherits color from the nearest [IconTheme].
  const TsaiIcon(
    IconData icon, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  }) : _icon = icon,
       _emoji = null,
       _child = null,
       assert(size > 0);

  /// Creates an emoji icon.
  ///
  /// Emoji are rendered at 80 percent of [size], matching the Penpot flag slot.
  const TsaiIcon.emoji(
    String emoji, {
    super.key,
    this.size = 24,
    this.semanticLabel,
  }) : color = null,
       _icon = null,
       _emoji = emoji,
       _child = null,
       assert(size > 0),
       assert(emoji.length > 0);

  /// Creates an icon from an arbitrary widget, such as SVG or PNG content.
  ///
  /// The child is constrained to the square [size]. [color] is exposed through
  /// [IconTheme], so custom children may opt into the inherited icon color.
  const TsaiIcon.custom(
    Widget child, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  }) : _icon = null,
       _emoji = null,
       _child = child,
       assert(size > 0);

  final IconData? _icon;
  final String? _emoji;
  final Widget? _child;

  /// The square extent and glyph size in logical pixels.
  final double size;

  /// An optional color override.
  final Color? color;

  /// An optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final Widget icon = switch ((_icon, _emoji, _child)) {
      (final icon?, null, null) => Icon(icon, size: size, color: color),
      (null, final emoji?, null) => Text(
        emoji,
        maxLines: 1,
        textScaler: TextScaler.noScaling,
        style: TextStyle(fontSize: size * 0.8, height: 1),
      ),
      (null, null, final child?) => IconTheme.merge(
        data: IconThemeData(size: size, color: color),
        child: child,
      ),
      _ => throw StateError('TsaiIcon requires exactly one icon source.'),
    };
    final square = SizedBox.square(
      dimension: size,
      child: Center(child: icon),
    );
    if (semanticLabel == null) {
      return ExcludeSemantics(child: square);
    }
    return Semantics(
      image: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: square,
    );
  }
}
