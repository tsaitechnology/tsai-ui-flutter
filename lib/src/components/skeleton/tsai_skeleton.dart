import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// Sizes shared by Tsai Skeleton placeholders.
enum TsaiSkeletonSize {
  /// Small placeholder.
  small,

  /// Medium placeholder.
  medium,

  /// Large placeholder.
  large,
}

/// A single-line text placeholder with a pill radius.
class TsaiSkeletonText extends StatelessWidget {
  /// Creates a text Skeleton that fills the available width.
  const TsaiSkeletonText({
    super.key,
    this.size = TsaiSkeletonSize.medium,
    this.animate = true,
    this.semanticLabel,
  });

  /// Placeholder height: 8, 12, or 16 pixels.
  final TsaiSkeletonSize size;

  /// Whether the shimmer animation is enabled.
  final bool animate;

  /// Optional loading description exposed to assistive technology.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final height = switch (size) {
      TsaiSkeletonSize.small => 8.0,
      TsaiSkeletonSize.medium => 12.0,
      TsaiSkeletonSize.large => 16.0,
    };
    return _TsaiSkeleton(
      height: height,
      borderRadius: BorderRadius.circular(tokens.radii.pill),
      animate: animate,
      semanticLabel: semanticLabel,
    );
  }
}

/// A circular avatar placeholder.
class TsaiSkeletonAvatar extends StatelessWidget {
  /// Creates an avatar Skeleton.
  const TsaiSkeletonAvatar({
    super.key,
    this.size = TsaiSkeletonSize.medium,
    this.animate = true,
    this.semanticLabel,
  });

  /// Diameter: 32, 40, or 48 pixels.
  final TsaiSkeletonSize size;

  /// Whether the shimmer animation is enabled.
  final bool animate;

  /// Optional loading description exposed to assistive technology.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final diameter = switch (size) {
      TsaiSkeletonSize.small => 32.0,
      TsaiSkeletonSize.medium => 40.0,
      TsaiSkeletonSize.large => 48.0,
    };
    return _TsaiSkeleton(
      width: diameter,
      height: diameter,
      borderRadius: BorderRadius.circular(diameter / 2),
      animate: animate,
      semanticLabel: semanticLabel,
    );
  }
}

/// A flexible-width card placeholder.
class TsaiSkeletonCard extends StatelessWidget {
  /// Creates a card Skeleton that fills the available width.
  const TsaiSkeletonCard({
    super.key,
    this.size = TsaiSkeletonSize.medium,
    this.animate = true,
    this.semanticLabel,
  });

  /// Placeholder height: 64, 96, or 160 pixels.
  final TsaiSkeletonSize size;

  /// Whether the shimmer animation is enabled.
  final bool animate;

  /// Optional loading description exposed to assistive technology.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final height = switch (size) {
      TsaiSkeletonSize.small => 64.0,
      TsaiSkeletonSize.medium => 96.0,
      TsaiSkeletonSize.large => 160.0,
    };
    return _TsaiSkeleton(
      height: height,
      borderRadius: BorderRadius.circular(tokens.radii.large),
      animate: animate,
      semanticLabel: semanticLabel,
    );
  }
}

class _TsaiSkeleton extends StatefulWidget {
  const _TsaiSkeleton({
    required this.height,
    required this.borderRadius,
    required this.animate,
    required this.semanticLabel,
    this.width = double.infinity,
  });

  final double width;
  final double height;
  final BorderRadius borderRadius;
  final bool animate;
  final String? semanticLabel;

  @override
  State<_TsaiSkeleton> createState() => _TsaiSkeletonState();
}

class _TsaiSkeletonState extends State<_TsaiSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  bool get _shouldAnimate =>
      widget.animate && !MediaQuery.disableAnimationsOf(context);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant _TsaiSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  void _syncAnimation() {
    if (_shouldAnimate) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final placeholder = ClipRRect(
      borderRadius: widget.borderRadius,
      child: SizedBox(
        key: const ValueKey<String>('tsai-skeleton-surface'),
        width: widget.width,
        height: widget.height,
        child: DecoratedBox(
          decoration: BoxDecoration(color: tokens.colors.surfaceSkeleton),
          child: _shouldAnimate
              ? AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    final offset = -3 + (_controller.value * 6);
                    return DecoratedBox(
                      key: const ValueKey<String>('tsai-skeleton-shimmer'),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(offset - 1, -0.2),
                          end: Alignment(offset + 1, 0.2),
                          colors: const [
                            Color(0x008C8FA6),
                            Color(0x338C8FA6),
                            Color(0x008C8FA6),
                          ],
                          stops: const [0.05, 0.5, 0.95],
                        ),
                      ),
                    );
                  },
                )
              : null,
        ),
      ),
    );
    if (widget.semanticLabel case final label?) {
      return Semantics(
        label: label,
        readOnly: true,
        excludeSemantics: true,
        child: placeholder,
      );
    }
    return ExcludeSemantics(child: placeholder);
  }
}
