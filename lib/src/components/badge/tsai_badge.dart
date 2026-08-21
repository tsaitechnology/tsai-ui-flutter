// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// Semantic tone used by Tsai status indicators.
enum TsaiBadgeTone { neutral, accent, info, success, error, warning }

Color _badgeColor(TsaiThemeTokens t, TsaiBadgeTone tone) => switch (tone) {
  TsaiBadgeTone.neutral => t.colors.contentSecondary,
  TsaiBadgeTone.accent => t.colors.contentAccent,
  TsaiBadgeTone.info => t.colors.accentInfo,
  TsaiBadgeTone.success => t.colors.accentSuccess,
  TsaiBadgeTone.error => t.colors.accentError,
  TsaiBadgeTone.warning => t.colors.accentWarning,
};

/// A compact status pill with an optional leading dot.
class TsaiBadge extends StatelessWidget {
  const TsaiBadge({
    required this.label,
    this.tone = TsaiBadgeTone.neutral,
    this.showDot = false,
    super.key,
  });
  final String label;
  final TsaiBadgeTone tone;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final t = TsaiThemeTokens.of(context);
    final color = _badgeColor(t, tone);
    final background = switch (tone) {
      TsaiBadgeTone.neutral => t.colors.surfaceRaised,
      TsaiBadgeTone.accent => t.colors.surfaceAccent,
      TsaiBadgeTone.info => t.colors.statusSurfaceInfo,
      TsaiBadgeTone.success => t.colors.statusSurfaceSuccess,
      TsaiBadgeTone.error => t.colors.statusSurfaceError,
      TsaiBadgeTone.warning => t.colors.statusSurfaceWarning,
    };
    final border = switch (tone) {
      TsaiBadgeTone.neutral => t.colors.borderStrong,
      TsaiBadgeTone.accent => t.colors.actionPrimarySoft,
      TsaiBadgeTone.info => t.colors.statusBorderInfo,
      TsaiBadgeTone.success => t.colors.statusBorderSuccess,
      TsaiBadgeTone.error => t.colors.statusBorderError,
      TsaiBadgeTone.warning => t.colors.statusBorderWarning,
    };
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(label, style: t.typography.captionMedium.copyWith(color: color)),
        ],
      ),
    );
  }
}

/// A compact notification count pill. Values above 99 are shown as `99+`.
class TsaiBadgeCounter extends StatelessWidget {
  const TsaiBadgeCounter({
    required this.value,
    this.tone = TsaiBadgeTone.accent,
    super.key,
  });
  final int value;
  final TsaiBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final t = TsaiThemeTokens.of(context);
    final color = tone == TsaiBadgeTone.error
        ? t.colors.actionDanger
        : t.colors.actionPrimary;
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        value > 99 ? '99+' : '$value',
        style: t.typography.captionSmall.copyWith(
          color: t.colors.contentOnActionPrimary,
        ),
      ),
    );
  }
}

/// An 8 pixel status indicator.
class TsaiBadgeDot extends StatelessWidget {
  const TsaiBadgeDot({this.tone = TsaiBadgeTone.accent, super.key});
  final TsaiBadgeTone tone;
  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(
      color: _badgeColor(TsaiThemeTokens.of(context), tone),
      shape: BoxShape.circle,
    ),
  );
}
