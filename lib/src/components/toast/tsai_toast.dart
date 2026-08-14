import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';

/// Penpot-supported Toast compositions.
enum TsaiToastVariant {
  /// Shows an action followed by a countdown indicator.
  undo,

  /// Shows an action followed by a close control.
  action,

  /// Shows only the message and close control.
  info,
}

/// A compact glass notification matching the Penpot Toast component.
class TsaiToast extends StatelessWidget {
  /// Creates a Toast.
  const TsaiToast({
    required this.message,
    super.key,
    this.variant = TsaiToastVariant.info,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
    this.secondsRemaining = 5,
    this.countdownProgress = 0.75,
  }) : assert(secondsRemaining >= 0),
       assert(countdownProgress >= 0 && countdownProgress <= 1);

  /// Primary Toast message.
  final String message;

  /// Composition shown by the Toast.
  final TsaiToastVariant variant;

  /// Optional replacement for the default 20-pixel information icon.
  final Widget? icon;

  /// Action label. Defaults to `Undo` or `Retry` for matching variants.
  final String? actionLabel;

  /// Called when the action is activated.
  final VoidCallback? onAction;

  /// Called when the close control is activated.
  final VoidCallback? onDismiss;

  /// Integer displayed in the undo countdown.
  final int secondsRemaining;

  /// Remaining countdown fraction in the range zero to one.
  final double countdownProgress;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final borderRadius = BorderRadius.circular(tokens.radii.pill);
    final resolvedActionLabel =
        actionLabel ??
        switch (variant) {
          TsaiToastVariant.undo => 'Undo',
          TsaiToastVariant.action => 'Retry',
          TsaiToastVariant.info => null,
        };
    final endPadding = variant == TsaiToastVariant.undo
        ? tokens.spacing.space16
        : tokens.spacing.space8;

    return Semantics(
      container: true,
      liveRegion: true,
      explicitChildNodes: true,
      child: IntrinsicWidth(
        stepWidth: 2,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            key: const ValueKey<String>('tsai-toast-filter'),
            filter: ImageFilter.blur(
              sigmaX: tokens.effects.glassBlur,
              sigmaY: tokens.effects.glassBlur,
            ),
            child: DecoratedBox(
              key: const ValueKey<String>('tsai-toast-surface'),
              decoration: BoxDecoration(
                color: tokens.colors.surfaceAccentGlassDim,
                border: Border.all(
                  color: tokens.colors.borderSubtle,
                  width: tokens.borders.hairline,
                ),
                borderRadius: borderRadius,
              ),
              child: SizedBox(
                height: 48,
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: tokens.spacing.space16,
                    end: endPadding,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconTheme.merge(
                        data: IconThemeData(color: tokens.colors.iconPrimary),
                        child:
                            icon ?? const TsaiIcon(LucideIcons.info, size: 20),
                      ),
                      SizedBox(width: tokens.spacing.space8),
                      Text(
                        message,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tokens.typography.bodyMediumMedium.copyWith(
                          color: tokens.colors.contentPrimary,
                        ),
                      ),
                      if (resolvedActionLabel case final label?) ...[
                        SizedBox(width: tokens.spacing.space8),
                        _ToastAction(label: label, onPressed: onAction),
                      ],
                      SizedBox(width: tokens.spacing.space8),
                      switch (variant) {
                        TsaiToastVariant.undo => _ToastCountdown(
                          seconds: secondsRemaining,
                          progress: countdownProgress,
                        ),
                        TsaiToastVariant.action || TsaiToastVariant.info =>
                          _ToastClose(onPressed: onDismiss),
                      },
                    ],
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

class _ToastAction extends StatelessWidget {
  const _ToastAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Semantics(
      button: true,
      enabled: onPressed != null,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: const ValueKey<String>('tsai-toast-action'),
          onTap: onPressed,
          borderRadius: BorderRadius.circular(tokens.radii.small),
          child: SizedBox(
            height: 32,
            child: Align(
              child: Text(
                label,
                style: tokens.typography.bodyMediumMedium.copyWith(
                  color: tokens.colors.actionPrimarySoft,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastClose extends StatelessWidget {
  const _ToastClose({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Tooltip(
      message: 'Dismiss',
      child: Semantics(
        button: true,
        enabled: onPressed != null,
        label: 'Dismiss',
        excludeSemantics: true,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            key: const ValueKey<String>('tsai-toast-close'),
            onTap: onPressed,
            borderRadius: BorderRadius.circular(tokens.radii.pill),
            child: SizedBox.square(
              dimension: 32,
              child: Center(
                child: TsaiIcon(
                  LucideIcons.x,
                  size: 16,
                  color: tokens.colors.iconSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastCountdown extends StatelessWidget {
  const _ToastCountdown({required this.seconds, required this.progress});

  final int seconds;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Semantics(
      label: '$seconds seconds remaining',
      excludeSemantics: true,
      child: SizedBox.square(
        key: const ValueKey<String>('tsai-toast-countdown'),
        dimension: 28,
        child: CustomPaint(
          painter: _CountdownPainter(
            color: tokens.colors.actionPrimarySoft,
            progress: progress,
          ),
          child: Center(
            child: Text(
              '$seconds',
              style: tokens.typography.captionMedium.copyWith(
                color: tokens.colors.contentPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownPainter extends CustomPainter {
  const _CountdownPainter({required this.color, required this.progress});

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final rect = Rect.fromLTWH(3.5, 3.5, size.width - 7, size.height - 7);
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2 * progress, false, paint);
  }

  @override
  bool shouldRepaint(_CountdownPainter oldDelegate) =>
      color != oldDelegate.color || progress != oldDelegate.progress;
}
