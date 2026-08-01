part of '../tsai_selection_controls.dart';

/// A controlled switch matching the Penpot Switch component.
class TsaiSwitch extends StatelessWidget {
  /// Creates a Tsai switch.
  const TsaiSwitch({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.description,
    this.labelPosition = TsaiControlLabelPosition.right,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.semanticLabel,
  });

  /// Current switch state.
  final bool value;

  /// Called with the next state, or null when disabled.
  final ValueChanged<bool>? onChanged;

  /// Optional visible label.
  final String? label;

  /// Optional secondary text below [label].
  final String? description;

  /// Position of the label content.
  final TsaiControlLabelPosition labelPosition;

  /// Whether the control requests focus initially.
  final bool autofocus;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Called when keyboard focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Optional accessibility label replacing the visible label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) => _TsaiSelectionControl(
    value: value,
    enabled: onChanged != null,
    label: label,
    description: description,
    labelPosition: labelPosition,
    autofocus: autofocus,
    focusNode: focusNode,
    onFocusChange: onFocusChange,
    semanticLabel: semanticLabel,
    isSwitch: true,
    onActivate: onChanged == null ? null : () => onChanged!(!value),
    controlBuilder: (context, focused, hovered) {
      final tokens = TsaiThemeTokens.of(context);
      final colors = tokens.colors;
      final enabled = onChanged != null;
      final background = enabled
          ? (value ? colors.actionPrimary : colors.surface)
          : colors.surfaceRaised;
      final border = focused
          ? colors.actionPrimarySoft
          : enabled
          ? (hovered ? colors.actionPrimarySoft : colors.borderStrong)
          : colors.borderSubtle;
      final thumb = enabled
          ? (value ? colors.iconOnAction : colors.iconSecondary)
          : colors.iconTertiary;
      return AnimatedContainer(
        key: const ValueKey<String>('tsai-switch-track'),
        duration: _duration(context, tokens),
        width: 36,
        height: 20,
        padding: EdgeInsets.all(tokens.spacing.space2),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(tokens.radii.pill),
          border: value && enabled && !focused
              ? null
              : Border.all(
                  color: border,
                  width: focused
                      ? tokens.borders.hairline * 2
                      : tokens.borders.hairline,
                ),
        ),
        child: AnimatedAlign(
          duration: _duration(context, tokens),
          curve: tokens.motion.interactionCurve,
          alignment: value
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          child: Container(
            key: const ValueKey<String>('tsai-switch-thumb'),
            width: 16,
            height: 16,
            decoration: BoxDecoration(color: thumb, shape: BoxShape.circle),
          ),
        ),
      );
    },
  );
}
