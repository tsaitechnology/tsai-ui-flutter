import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';
import '../divider/tsai_divider.dart';
import '../typography/tsai_text.dart';

/// An expandable settings or FAQ row matching the Penpot Accordion.
class TsaiAccordion extends StatelessWidget {
  /// Creates an accordion row.
  const TsaiAccordion({
    required this.title,
    required this.body,
    required this.expanded,
    super.key,
    this.onChanged,
    this.showDivider = false,
  });

  /// Header title.
  final String title;

  /// Body copy shown while expanded.
  final String body;

  /// Whether the body is visible.
  final bool expanded;

  /// Called with the next expanded state.
  final ValueChanged<bool>? onChanged;

  /// Whether to paint a hairline under the row.
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      key: const ValueKey<String>('tsai-accordion'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onChanged == null ? null : () => onChanged!(!expanded),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            child: SizedBox(
              height: 56,
              child: Row(
                children: [
                  Expanded(
                    child: TsaiTextBody(
                      title,
                      size: TsaiBodySize.medium,
                      weight: TsaiTextWeight.medium,
                      color: tokens.colors.contentPrimary,
                    ),
                  ),
                  AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: tokens.motion.interaction,
                    curve: tokens.motion.interactionCurve,
                    child: TsaiIcon(
                      LucideIcons.chevron_down,
                      size: tokens.spacing.space20,
                      color: tokens.colors.iconSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (expanded)
          Padding(
            padding: EdgeInsets.only(bottom: tokens.spacing.space16),
            child: TsaiTextBody(
              body,
              size: TsaiBodySize.medium,
              weight: TsaiTextWeight.regular,
              color: tokens.colors.contentSecondary,
            ),
          ),
        if (showDivider) const TsaiDivider(),
      ],
    );
  }
}
