import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import 'avatar.dart';

/// A compact user summary composed from an [Avatar] and a name.
class UserPill extends StatelessWidget {
  /// Creates a user pill.
  const UserPill({
    required this.name,
    required this.initials,
    super.key,
    this.avatarUrl,
    this.onPressed,
    this.semanticLabel,
  }) : assert(name.length > 0),
       assert(initials.length > 0);

  /// The visible user name.
  final String name;

  /// Initials used when no network image is available.
  final String initials;

  /// Optional network image URL for the avatar.
  final String? avatarUrl;

  /// Called when the pill is activated, or null for a display-only pill.
  final VoidCallback? onPressed;

  /// Optional accessibility label for an interactive pill.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final content = SizedBox(
      height: 40,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 4, end: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Avatar(initials: initials, imageUrl: avatarUrl),
            SizedBox(width: tokens.spacing.space8),
            Flexible(
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: tokens.typography.bodyMediumMedium.copyWith(
                  color: tokens.colors.contentPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    final pill = onPressed == null
        ? _UserPillSurface(child: content)
        : Semantics(
            button: true,
            label: semanticLabel,
            excludeSemantics: semanticLabel != null,
            child: _UserPillSurface(
              child: InkWell(
                onTap: onPressed,
                splashFactory: NoSplash.splashFactory,
                hoverColor: tokens.colors.surfaceRaised,
                highlightColor: tokens.colors.surfaceRaised,
                child: content,
              ),
            ),
          );
    return pill;
  }
}

class _UserPillSurface extends StatelessWidget {
  const _UserPillSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final borderRadius = BorderRadius.circular(tokens.radii.pill);
    return ClipRRect(
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
          child: Material(type: MaterialType.transparency, child: child),
        ),
      ),
    );
  }
}
