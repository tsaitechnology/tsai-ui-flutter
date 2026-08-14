import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A token-backed card surface with an optional title row and arbitrary body.
class TsaiCard extends StatelessWidget {
  /// Creates a Card.
  const TsaiCard({required this.child, super.key, this.title, this.trailing});

  /// Arbitrary content placed inside the card.
  final Widget child;

  /// Optional header title rendered with the Penpot card-title style.
  final String? title;

  /// Optional 20-pixel header action or status slot.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final hasHeader = title != null || trailing != null;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        key: const ValueKey<String>('tsai-card-surface'),
        decoration: BoxDecoration(
          color: tokens.colors.surface,
          border: Border.all(
            color: tokens.colors.borderSubtle,
            width: tokens.borders.hairline,
          ),
          borderRadius: BorderRadius.circular(tokens.radii.large),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing.space16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasHeader) ...[
                SizedBox(
                  height: 20,
                  child: Row(
                    children: [
                      if (title case final title?)
                        Expanded(
                          child: Semantics(
                            header: true,
                            child: Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: tokens.typography.bodyLargeMedium.copyWith(
                                color: tokens.colors.contentPrimary,
                              ),
                            ),
                          ),
                        )
                      else
                        const Spacer(),
                      if (trailing case final trailing?)
                        SizedBox.square(
                          dimension: 20,
                          child: IconTheme.merge(
                            data: IconThemeData(
                              size: 20,
                              color: tokens.colors.iconSecondary,
                            ),
                            child: trailing,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: tokens.spacing.space16),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
