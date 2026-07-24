import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';

/// A compact inline action matching the Penpot Link component.
///
/// Set [onPressed] to null to render the disabled state. Optional icons use
/// the component's 16-pixel slots and remain excluded from semantics unless
/// they provide their own semantic labels.
class TsaiLink extends StatelessWidget {
  /// Creates a Tsai link.
  const TsaiLink({
    required this.label,
    required this.onPressed,
    super.key,
    this.leadingIcon,
    this.trailingIcon,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
  });

  /// Visible link label.
  final String label;

  /// Called when activated, or null when disabled.
  final VoidCallback? onPressed;

  /// Optional leading icon, normally a 16-pixel [TsaiIcon].
  final TsaiIcon? leadingIcon;

  /// Optional trailing icon, normally a 16-pixel [TsaiIcon].
  final TsaiIcon? trailingIcon;

  /// Whether the link requests focus when first shown.
  final bool autofocus;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Optional accessibility label that replaces descendant semantics.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final enabled = onPressed != null;
    Color foreground(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return tokens.colors.contentTertiary;
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.pressed)) {
        return tokens.colors.actionPrimary;
      }
      return tokens.colors.actionPrimarySoft;
    }

    final link = TextButton(
      onPressed: onPressed,
      autofocus: autofocus,
      focusNode: focusNode,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith(foreground),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
        elevation: const WidgetStatePropertyAll(0),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        minimumSize: const WidgetStatePropertyAll(Size(0, 32)),
        maximumSize: const WidgetStatePropertyAll(Size.infinite),
        tapTargetSize: MaterialTapTargetSize.padded,
        visualDensity: VisualDensity.standard,
        textStyle: WidgetStateProperty.resolveWith(
          (states) => tokens.typography.bodyMediumMedium.copyWith(
            decoration: states.contains(WidgetState.focused)
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: foreground(states),
          ),
        ),
      ),
      child: IconTheme.merge(
        data: IconThemeData(
          size: 16,
          color: enabled ? null : tokens.colors.iconTertiary,
        ),
        child: _TsaiLinkContent(
          label: label,
          leadingIcon: leadingIcon,
          trailingIcon: trailingIcon,
          gap: tokens.spacing.space4,
        ),
      ),
    );
    if (semanticLabel == null) {
      return link;
    }
    return Semantics(
      button: true,
      enabled: enabled,
      link: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: link,
    );
  }
}

class _TsaiLinkContent extends StatelessWidget {
  const _TsaiLinkContent({
    required this.label,
    required this.leadingIcon,
    required this.trailingIcon,
    required this.gap,
  });

  final String label;
  final TsaiIcon? leadingIcon;
  final TsaiIcon? trailingIcon;
  final double gap;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (leadingIcon case final icon?) ...[icon, SizedBox(width: gap)],
      Flexible(
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      if (trailingIcon case final icon?) ...[SizedBox(width: gap), icon],
    ],
  );
}
