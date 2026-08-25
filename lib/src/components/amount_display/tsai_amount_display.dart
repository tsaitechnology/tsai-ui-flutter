import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../typography/tsai_text.dart';

/// Horizontal alignment of [TsaiAmountDisplay] layers.
enum TsaiAmountAlignment {
  /// Start-aligned stack used on Home.
  start,

  /// Centered stack used on Transfer entry.
  center,
}

/// A caption / value / sub-line amount stack matching Penpot Amount Display.
class TsaiAmountDisplay extends StatelessWidget {
  /// Creates an amount display.
  const TsaiAmountDisplay({
    required this.value,
    super.key,
    this.caption,
    this.subtitle,
    this.alignment = TsaiAmountAlignment.start,
    this.captionColor,
    this.valueColor,
    this.subtitleColor,
  });

  /// Primary amount string, including currency.
  final String value;

  /// Optional label above the amount.
  final String? caption;

  /// Optional supporting line below the amount.
  final String? subtitle;

  /// Column alignment.
  final TsaiAmountAlignment alignment;

  /// Optional caption color override.
  final Color? captionColor;

  /// Optional value color override.
  final Color? valueColor;

  /// Optional subtitle color override.
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final cross = alignment == TsaiAmountAlignment.center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final textAlign = alignment == TsaiAmountAlignment.center
        ? TextAlign.center
        : TextAlign.start;
    return Column(
      key: const ValueKey<String>('tsai-amount-display'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: cross,
      children: [
        if (caption case final caption?)
          TsaiTextCaption(
            caption,
            size: TsaiCaptionSize.medium,
            weight: TsaiTextWeight.regular,
            color: captionColor ?? tokens.colors.contentSecondary,
            textAlign: textAlign,
          ),
        if (caption != null) SizedBox(height: tokens.spacing.space6),
        TsaiTextMonoHeading(
          value,
          size: TsaiMonoHeadingSize.extraLarge,
          color: valueColor ?? tokens.colors.contentPrimary,
          textAlign: textAlign,
        ),
        if (subtitle case final subtitle?) ...[
          SizedBox(height: tokens.spacing.space6),
          TsaiTextCaption(
            subtitle,
            size: TsaiCaptionSize.medium,
            weight: TsaiTextWeight.regular,
            color: subtitleColor ?? tokens.colors.contentTertiary,
            textAlign: textAlign,
          ),
        ],
      ],
    );
  }
}
