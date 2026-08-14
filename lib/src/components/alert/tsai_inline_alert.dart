import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';

/// Semantic tones supported by the Penpot Inline Alert component.
enum TsaiInlineAlertTone {
  /// Informational guidance.
  info,

  /// Successful completion or confirmation.
  success,

  /// Error or failed operation.
  error,

  /// Warning that needs attention.
  warning,
}

/// A dismissible inline status message.
class TsaiInlineAlert extends StatelessWidget {
  /// Creates an Inline Alert.
  const TsaiInlineAlert({
    required this.title,
    required this.message,
    required this.onDismiss,
    super.key,
    this.tone = TsaiInlineAlertTone.info,
    this.icon,
  });

  /// Short alert heading.
  final String title;

  /// Supporting explanation and next step.
  final String message;

  /// Called when the close control is activated, or null when disabled.
  final VoidCallback? onDismiss;

  /// Semantic color and icon treatment.
  final TsaiInlineAlertTone tone;

  /// Optional replacement for the tone's default 20-pixel icon.
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final style = _AlertStyle.resolve(tokens.colors, tone);
    final borderRadius = BorderRadius.circular(tokens.radii.medium);

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        key: const ValueKey<String>('tsai-inline-alert-surface'),
        decoration: BoxDecoration(
          color: style.surface,
          border: Border.all(
            color: style.border,
            width: tokens.borders.hairline,
          ),
          borderRadius: borderRadius,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: tokens.spacing.space16,
            top: tokens.spacing.space12,
            end: tokens.spacing.space8,
            bottom: tokens.spacing.space12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconTheme.merge(
                data: IconThemeData(color: style.accent),
                child:
                    icon ?? TsaiIcon(style.icon, size: 20, color: style.accent),
              ),
              SizedBox(width: tokens.spacing.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(
                        title,
                        style: tokens.typography.bodyMediumMedium.copyWith(
                          color: tokens.colors.contentPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: tokens.spacing.space2),
                    Text(
                      message,
                      style: tokens.typography.captionMediumRegular.copyWith(
                        color: tokens.colors.contentPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: tokens.spacing.space4),
              Transform.translate(
                offset: const Offset(0, -6),
                child: _AlertClose(onPressed: onDismiss),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertClose extends StatelessWidget {
  const _AlertClose({required this.onPressed});

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
            key: const ValueKey<String>('tsai-inline-alert-close'),
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

final class _AlertStyle {
  const _AlertStyle({
    required this.surface,
    required this.border,
    required this.accent,
    required this.icon,
  });

  final Color surface;
  final Color border;
  final Color accent;
  final IconData icon;

  static _AlertStyle resolve(
    TsaiColorTokens colors,
    TsaiInlineAlertTone tone,
  ) => switch (tone) {
    TsaiInlineAlertTone.info => _AlertStyle(
      surface: colors.statusSurfaceInfo,
      border: colors.statusBorderInfo,
      accent: colors.accentInfo,
      icon: LucideIcons.info,
    ),
    TsaiInlineAlertTone.success => _AlertStyle(
      surface: colors.statusSurfaceSuccess,
      border: colors.statusBorderSuccess,
      accent: colors.accentSuccess,
      icon: LucideIcons.circle_check,
    ),
    TsaiInlineAlertTone.error => _AlertStyle(
      surface: colors.statusSurfaceError,
      border: colors.statusBorderError,
      accent: colors.accentError,
      icon: LucideIcons.circle_alert,
    ),
    TsaiInlineAlertTone.warning => _AlertStyle(
      surface: colors.statusSurfaceWarning,
      border: colors.statusBorderWarning,
      accent: colors.accentWarning,
      icon: LucideIcons.triangle_alert,
    ),
  };
}
