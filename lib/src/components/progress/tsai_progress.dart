import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// Semantic visual states for [TsaiProgressBar].
enum TsaiProgressBarState {
  /// In-progress accent treatment.
  normal,

  /// Completed success treatment.
  success,

  /// Failed progress treatment.
  error,
}

/// Penpot-supported label arrangements for [TsaiProgressBar].
enum TsaiProgressBarLabelPosition {
  /// Percentage to the left of the track.
  left,

  /// Percentage to the right of the track.
  right,

  /// Title and percentage above the track.
  top,

  /// Title left and percentage right of the track.
  both,
}

/// A determinate four-pixel progress indicator.
class TsaiProgressBar extends StatelessWidget {
  /// Creates a Progress Bar.
  const TsaiProgressBar({
    required this.value,
    super.key,
    this.state = TsaiProgressBarState.normal,
    this.labelPosition = TsaiProgressBarLabelPosition.right,
    this.label = 'Label',
    this.semanticLabel,
  }) : assert(value >= 0 && value <= 1);

  /// Completed fraction in the range zero to one.
  final double value;

  /// Semantic color state.
  final TsaiProgressBarState state;

  /// Placement of the visible label or percentage.
  final TsaiProgressBarLabelPosition labelPosition;

  /// Title shown by the top and both arrangements.
  final String label;

  /// Optional accessibility label for the progress indicator.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final percentage = '${(value * 100).round()}%';
    final track = Expanded(
      child: _ProgressTrack(value: value, state: state),
    );
    final percentageText = Text(
      percentage,
      key: const ValueKey<String>('tsai-progress-percentage'),
      style: tokens.typography.monoCaption.copyWith(
        color: tokens.colors.contentSecondary,
      ),
    );

    final content = switch (labelPosition) {
      TsaiProgressBarLabelPosition.left => Row(
        children: [
          percentageText,
          SizedBox(width: tokens.spacing.space12),
          track,
        ],
      ),
      TsaiProgressBarLabelPosition.right => Row(
        children: [
          track,
          SizedBox(width: tokens.spacing.space12),
          percentageText,
        ],
      ),
      TsaiProgressBarLabelPosition.top => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: tokens.typography.captionMedium.copyWith(
                  color: tokens.colors.contentPrimary,
                ),
              ),
              percentageText,
            ],
          ),
          SizedBox(height: tokens.spacing.space8),
          SizedBox(
            height: 4,
            child: _ProgressTrack(value: value, state: state),
          ),
        ],
      ),
      TsaiProgressBarLabelPosition.both => Row(
        children: [
          Text(
            label,
            style: tokens.typography.monoCaption.copyWith(
              color: tokens.colors.contentPrimary,
            ),
          ),
          SizedBox(width: tokens.spacing.space12),
          track,
          SizedBox(width: tokens.spacing.space12),
          percentageText,
        ],
      ),
    };

    return Semantics(
      label: semanticLabel ?? label,
      value: percentage,
      excludeSemantics: true,
      child: content,
    );
  }
}

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.value, required this.state});

  final double value;
  final TsaiProgressBarState state;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final fillColor = switch (state) {
      TsaiProgressBarState.normal => tokens.colors.actionPrimary,
      TsaiProgressBarState.success => tokens.colors.accentSuccess,
      TsaiProgressBarState.error => tokens.colors.accentError,
    };
    final borderRadius = BorderRadius.circular(tokens.radii.pill);
    return SizedBox(
      key: const ValueKey<String>('tsai-progress-track'),
      height: 4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.colors.borderSubtle,
          borderRadius: borderRadius,
        ),
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: value, end: value),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : tokens.motion.progressIndicator,
          curve: tokens.motion.transitionCurve,
          builder: (context, animatedValue, _) => FractionallySizedBox(
            key: const ValueKey<String>('tsai-progress-fill'),
            widthFactor: animatedValue,
            alignment: AlignmentDirectional.centerStart,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Penpot-supported spinner sizes.
enum TsaiSpinnerSize {
  /// 16-pixel spinner with a 1.5-pixel stroke.
  small(16, 1.5),

  /// 24-pixel spinner with a two-pixel stroke.
  medium(24, 2),

  /// 32-pixel spinner with a 2.5-pixel stroke.
  large(32, 2.5);

  const TsaiSpinnerSize(this.extent, this.strokeWidth);

  /// Square outer extent.
  final double extent;

  /// Arc stroke width.
  final double strokeWidth;
}

/// An animated accent spinner matching the Penpot loader arc.
class TsaiSpinner extends StatefulWidget {
  /// Creates a Spinner.
  const TsaiSpinner({
    super.key,
    this.size = TsaiSpinnerSize.medium,
    this.color,
    this.semanticLabel = 'Loading',
  });

  /// Outer spinner size.
  final TsaiSpinnerSize size;

  /// Optional arc color override.
  final Color? color;

  /// Accessibility label, or null for a decorative spinner.
  final String? semanticLabel;

  @override
  State<TsaiSpinner> createState() => _TsaiSpinnerState();
}

class _TsaiSpinnerState extends State<TsaiSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tokens = TsaiThemeTokens.of(context);
    _controller.duration = tokens.motion.progressIndicator;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
      _controller.value = 0;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
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
    final spinner = RotationTransition(
      turns: _controller,
      child: CustomPaint(
        key: const ValueKey<String>('tsai-spinner-paint'),
        size: Size.square(widget.size.extent),
        painter: _SpinnerPainter(
          color: widget.color ?? tokens.colors.actionPrimary,
          strokeWidth: widget.size.strokeWidth,
        ),
      ),
    );
    if (widget.semanticLabel == null) {
      return ExcludeSemantics(child: spinner);
    }
    return Semantics(
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: spinner,
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final arcExtent = size.width * 0.75;
    final inset = (size.width - arcExtent) / 2;
    final rect = Rect.fromLTWH(inset, inset, arcExtent, arcExtent);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 1.5, false, paint);
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) =>
      color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}
