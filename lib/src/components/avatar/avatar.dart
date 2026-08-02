import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A 32-pixel circular user avatar with an initials fallback.
class Avatar extends StatelessWidget {
  /// Creates an avatar.
  const Avatar({
    required this.initials,
    super.key,
    this.image,
    this.imageUrl,
    this.semanticLabel,
  }) : assert(initials.length > 0),
       assert(image == null || imageUrl == null);

  /// Initials displayed when [image] and [imageUrl] are absent or invalid.
  final String initials;

  /// Optional image from any Flutter image source.
  final ImageProvider<Object>? image;

  /// Optional network image URL.
  ///
  /// Use [image] for asset, memory, file, or custom image providers. Only one
  /// image source may be supplied.
  final String? imageUrl;

  /// Optional accessibility label for the avatar.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final fallback = ColoredBox(
      color: tokens.colors.borderStrong,
      child: Center(
        child: Text(
          initials,
          maxLines: 1,
          overflow: TextOverflow.clip,
          textScaler: TextScaler.noScaling,
          style: tokens.typography.captionSmall.copyWith(
            color: tokens.colors.contentPrimary,
          ),
        ),
      ),
    );
    final url = imageUrl;
    final provider =
        image ?? (url == null || url.isEmpty ? null : NetworkImage(url));
    final content = provider == null
        ? fallback
        : Image(
            image: provider,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                frame == null && !wasSynchronouslyLoaded ? fallback : child,
            errorBuilder: (context, error, stackTrace) => fallback,
          );
    final circle = ClipOval(
      child: SizedBox.square(dimension: 32, child: content),
    );
    final avatar = semanticLabel == null
        ? ExcludeSemantics(child: circle)
        : Semantics(
            image: true,
            label: semanticLabel,
            excludeSemantics: true,
            child: circle,
          );
    return Align(
      alignment: AlignmentDirectional.center,
      widthFactor: 1,
      heightFactor: 1,
      child: avatar,
    );
  }
}
