import 'package:flutter/widgets.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import 'tsai_text.dart';

/// A page title with optional supporting text.
///
/// The title and subtitle use the canonical Tsai typography and semantic
/// colors. Horizontal page padding belongs to the surrounding layout.
final class TsaiTitle extends StatelessWidget {
  /// Creates a page title.
  const TsaiTitle(this.title, {super.key, this.subtitle})
    : assert(title.length > 0),
      assert(subtitle == null || subtitle.length > 0);

  /// The primary page heading.
  final String title;

  /// Optional supporting text displayed below [title].
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TsaiTextHeading(
          title,
          size: TsaiHeadingSize.extraLarge,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
        if (subtitle case final subtitle?) ...[
          SizedBox(height: tokens.spacing.space4),
          TsaiTextBody(
            subtitle,
            size: TsaiBodySize.medium,
            weight: TsaiTextWeight.regular,
            color: tokens.colors.contentSecondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ],
      ],
    );
  }
}
