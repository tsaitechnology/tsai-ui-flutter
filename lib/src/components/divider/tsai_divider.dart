import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A one-pixel hairline separator matching the Penpot Divider.
class TsaiDivider extends StatelessWidget {
  /// Creates a divider.
  const TsaiDivider({super.key, this.indent = 0, this.endIndent = 0});

  /// Leading inset before the line.
  final double indent;

  /// Trailing inset after the line.
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(start: indent, end: endIndent),
      child: SizedBox(
        key: const ValueKey<String>('tsai-divider'),
        height: tokens.borders.hairline,
        width: double.infinity,
        child: ColoredBox(color: tokens.colors.borderSubtle),
      ),
    );
  }
}
