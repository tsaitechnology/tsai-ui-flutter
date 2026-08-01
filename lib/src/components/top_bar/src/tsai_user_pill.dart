part of '../tsai_top_bar.dart';

/// A compact user summary for a [HomeTopBar].
///
/// When [avatarUrl] is absent, loading, or fails to load, the 32-pixel avatar
/// displays [initials]. Set [onPressed] to make the whole pill interactive.
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
      height: tokens.spacing.space32 + tokens.spacing.space8,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: tokens.spacing.space4,
          end: tokens.spacing.space12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UserAvatar(avatarUrl: avatarUrl, initials: initials),
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
    if (onPressed == null) {
      return _HomeGlassSurface(child: content);
    }
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: _HomeGlassSurface(
        child: InkWell(
          onTap: onPressed,
          splashFactory: NoSplash.splashFactory,
          hoverColor: tokens.colors.surfaceRaised,
          highlightColor: tokens.colors.surfaceRaised,
          child: content,
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.avatarUrl, required this.initials});

  final String? avatarUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final fallback = ColoredBox(
      color: tokens.colors.surfaceAccentGlass,
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
    final url = avatarUrl;
    final avatar = url == null || url.isEmpty
        ? fallback
        : Image.network(
            url,
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                frame == null && !wasSynchronouslyLoaded ? fallback : child,
            errorBuilder: (context, error, stackTrace) => fallback,
          );
    return ClipOval(
      child: SizedBox.square(dimension: tokens.spacing.space32, child: avatar),
    );
  }
}
