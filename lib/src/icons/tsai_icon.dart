import 'package:flutter/material.dart';

/// A stable square adapter for Lucide or other Flutter [IconData].
class TsaiIcon extends StatelessWidget {
  /// Creates an icon that inherits color from the nearest [IconTheme].
  const TsaiIcon(
    this.icon, {
    super.key,
    this.size = 24,
    this.color,
    this.semanticLabel,
  }) : assert(size > 0);

  /// The glyph to display.
  final IconData icon;

  /// The square extent and glyph size in logical pixels.
  final double size;

  /// An optional color override.
  final Color? color;

  /// An optional accessibility label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: Center(
      child: Icon(icon, size: size, color: color, semanticLabel: semanticLabel),
    ),
  );
}
