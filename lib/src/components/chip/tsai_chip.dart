// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A selectable filter chip with optional leading and removable glyphs.
class TsaiChip extends StatelessWidget {
  const TsaiChip({
    required this.label,
    this.selected = false,
    this.showCheck = false,
    this.onDeleted,
    this.onTap,
    super.key,
  });
  final String label;
  final bool selected;
  final bool showCheck;
  final VoidCallback? onDeleted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = TsaiThemeTokens.of(context);
    final color = selected ? t.colors.contentAccent : t.colors.contentSecondary;
    return Semantics(
      button: onTap != null,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: selected ? t.colors.surfaceAccent : t.colors.surface,
            border: Border.all(
              color: selected
                  ? t.colors.actionPrimarySoft
                  : t.colors.borderSubtle,
            ),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showCheck) Icon(Icons.check, size: 16, color: color),
              if (showCheck) const SizedBox(width: 6),
              Text(
                label,
                style: t.typography.captionMedium.copyWith(color: color),
              ),
              if (onDeleted != null) ...[
                const SizedBox(width: 6),
                InkResponse(
                  onTap: onDeleted,
                  child: Icon(Icons.close, size: 16, color: color),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
