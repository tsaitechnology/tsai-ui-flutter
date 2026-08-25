import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../typography/tsai_text.dart';

/// Visual treatments defined by the Penpot Action Tile.
enum TsaiActionTileVariant {
  /// Circular 56-pixel plate with a caption below.
  circle,

  /// Filled 84×72 rounded plate.
  card,

  /// 84×72 plate without a default fill.
  ghost,
}

/// A Home quick-action tile matching the Penpot Action Tile.
class TsaiActionTile extends StatefulWidget {
  /// Creates an action tile.
  const TsaiActionTile({
    required this.icon,
    super.key,
    this.label,
    this.variant = TsaiActionTileVariant.circle,
    this.onPressed,
  });

  /// 24-pixel icon shown in the plate.
  final Widget icon;

  /// Optional caption. Hidden when null or empty.
  final String? label;

  /// Plate geometry and fill.
  final TsaiActionTileVariant variant;

  /// Called when the tile is activated.
  final VoidCallback? onPressed;

  @override
  State<TsaiActionTile> createState() => _TsaiActionTileState();
}

class _TsaiActionTileState extends State<TsaiActionTile> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final showCaption = widget.label != null && widget.label!.isNotEmpty;
    final icon = IconTheme.merge(
      data: IconThemeData(
        size: tokens.spacing.space24,
        color: tokens.colors.iconBright,
      ),
      child: SizedBox.square(
        dimension: tokens.spacing.space24,
        child: widget.icon,
      ),
    );
    final caption = showCaption
        ? TsaiTextCaption(
            widget.label!,
            size: TsaiCaptionSize.medium,
            weight: TsaiTextWeight.regular,
            color: tokens.colors.contentPrimary,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          )
        : null;

    final child = switch (widget.variant) {
      TsaiActionTileVariant.circle => SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _Plate(
              width: 56,
              height: 56,
              radius: tokens.radii.pill,
              color: _plateColor(tokens),
              child: icon,
            ),
            if (caption != null) ...[
              SizedBox(height: tokens.spacing.space8),
              caption,
            ],
          ],
        ),
      ),
      TsaiActionTileVariant.card || TsaiActionTileVariant.ghost => _Plate(
        width: 84,
        height: 72,
        radius: tokens.radii.large,
        color: _plateColor(tokens),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            if (caption != null) ...[
              SizedBox(height: tokens.spacing.space8),
              caption,
            ],
          ],
        ),
      ),
    };

    if (widget.onPressed == null) {
      return child;
    }
    return Semantics(
      button: true,
      label: widget.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: child,
      ),
    );
  }

  Color? _plateColor(TsaiThemeTokens tokens) {
    return switch (widget.variant) {
      TsaiActionTileVariant.circle || TsaiActionTileVariant.card =>
        _pressed ? tokens.colors.surfaceRaised : tokens.colors.surface,
      TsaiActionTileVariant.ghost => _pressed ? tokens.colors.surface : null,
    };
  }
}

class _Plate extends StatelessWidget {
  const _Plate({
    required this.width,
    required this.height,
    required this.radius,
    required this.child,
    this.color,
  });

  final double width;
  final double height;
  final double radius;
  final Color? color;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: TsaiThemeTokens.of(context).motion.interaction,
    curve: TsaiThemeTokens.of(context).motion.interactionCurve,
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
    alignment: Alignment.center,
    child: child,
  );
}
