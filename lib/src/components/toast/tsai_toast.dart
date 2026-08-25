import 'dart:async';
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

/// Why a presented Toast overlay was removed.
enum TsaiToastDismissReason {
  /// The Toast reached the end of [showTsaiToast] duration.
  timeout,

  /// The close control was activated, or a newer Toast replaced it.
  dismiss,

  /// The Toast action control was activated.
  action,
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
                    mainAxisSize: variant == TsaiToastVariant.undo
                        ? MainAxisSize.min
                        : MainAxisSize.max,
                    children: [
                      IconTheme.merge(
                        data: IconThemeData(color: tokens.colors.iconPrimary),
                        child:
                            icon ?? const TsaiIcon(LucideIcons.info, size: 20),
                      ),
                      SizedBox(width: tokens.spacing.space8),
                      if (variant == TsaiToastVariant.undo)
                        Flexible(
                          child: Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tokens.typography.bodyMediumMedium.copyWith(
                              color: tokens.colors.contentPrimary,
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: Text(
                            message,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: tokens.typography.bodyMediumMedium.copyWith(
                              color: tokens.colors.contentPrimary,
                            ),
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

OverlayEntry? _activeToastEntry;
Completer<TsaiToastDismissReason>? _activeToastCompleter;

/// Shows a non-blocking [TsaiToast] overlay and returns why it was dismissed.
///
/// The overlay does not install a modal barrier, so the rest of the UI stays
/// interactive. Presenting a new Toast replaces any Toast already shown.
///
/// The pill is centered horizontally and sits 12 pixels above [bottomClearance]
/// or, when that clearance is zero, above the system bottom safe area. Pass
/// [BottomNavBar.barHeightOf] as [bottomClearance] when a bottom navigation
/// bar overlays the screen, matching the Penpot Toast screens.
Future<TsaiToastDismissReason> showTsaiToast({
  required BuildContext context,
  required String message,
  TsaiToastVariant variant = TsaiToastVariant.info,
  Widget? icon,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 5),
  double bottomClearance = 0,
  bool useRootOverlay = true,
}) {
  assert(duration > Duration.zero);
  assert(bottomClearance >= 0);
  final overlay = Overlay.of(context, rootOverlay: useRootOverlay);
  _dismissActiveToast(TsaiToastDismissReason.dismiss);

  final completer = Completer<TsaiToastDismissReason>();
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (overlayContext) => _ToastOverlay(
      bottomClearance: bottomClearance,
      child: _PresentedToast(
        message: message,
        variant: variant,
        icon: icon,
        actionLabel: actionLabel,
        duration: duration,
        onAction: () {
          onAction?.call();
          _finishToast(entry, completer, TsaiToastDismissReason.action);
        },
        onDismiss: () =>
            _finishToast(entry, completer, TsaiToastDismissReason.dismiss),
        onTimeout: () =>
            _finishToast(entry, completer, TsaiToastDismissReason.timeout),
      ),
    ),
  );
  _activeToastEntry = entry;
  _activeToastCompleter = completer;
  overlay.insert(entry);
  return completer.future;
}

class _ToastOverlay extends StatelessWidget {
  const _ToastOverlay({required this.bottomClearance, required this.child});

  final double bottomClearance;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final media = MediaQuery.of(context);
    final reservedBelow = bottomClearance > 0
        ? bottomClearance
        : media.padding.bottom;
    return Padding(
      key: const ValueKey<String>('tsai-toast-overlay'),
      padding: EdgeInsets.fromLTRB(
        tokens.spacing.space16,
        tokens.spacing.space16,
        tokens.spacing.space16,
        tokens.spacing.space12 + reservedBelow + media.viewInsets.bottom,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Material(
          type: MaterialType.transparency,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 390),
            child: child,
          ),
        ),
      ),
    );
  }
}

void _dismissActiveToast(TsaiToastDismissReason reason) {
  final entry = _activeToastEntry;
  final completer = _activeToastCompleter;
  _activeToastEntry = null;
  _activeToastCompleter = null;
  if (entry != null && entry.mounted) {
    entry.remove();
  }
  if (completer != null && !completer.isCompleted) {
    completer.complete(reason);
  }
}

void _finishToast(
  OverlayEntry entry,
  Completer<TsaiToastDismissReason> completer,
  TsaiToastDismissReason reason,
) {
  if (_activeToastEntry == entry) {
    _activeToastEntry = null;
    _activeToastCompleter = null;
  }
  if (entry.mounted) {
    entry.remove();
  }
  if (!completer.isCompleted) {
    completer.complete(reason);
  }
}

class _PresentedToast extends StatefulWidget {
  const _PresentedToast({
    required this.message,
    required this.variant,
    required this.icon,
    required this.actionLabel,
    required this.duration,
    required this.onAction,
    required this.onDismiss,
    required this.onTimeout,
  });

  final String message;
  final TsaiToastVariant variant;
  final Widget? icon;
  final String? actionLabel;
  final Duration duration;
  final VoidCallback onAction;
  final VoidCallback onDismiss;
  final VoidCallback onTimeout;

  @override
  State<_PresentedToast> createState() => _PresentedToastState();
}

class _PresentedToastState extends State<_PresentedToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _timeout;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..forward();
    _timeout = Timer(widget.duration, widget.onTimeout);
  }

  @override
  void dispose() {
    _timeout?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _controller,
    builder: (context, _) {
      final remaining = widget.duration * (1 - _controller.value);
      return TsaiToast(
        message: widget.message,
        variant: widget.variant,
        icon: widget.icon,
        actionLabel: widget.actionLabel,
        secondsRemaining: remaining.inMilliseconds == 0
            ? 0
            : (remaining.inMilliseconds / 1000).ceil(),
        countdownProgress: 1 - _controller.value,
        onAction: widget.onAction,
        onDismiss: widget.onDismiss,
      );
    },
  );
}
