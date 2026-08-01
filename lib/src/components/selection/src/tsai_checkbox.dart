part of '../tsai_selection_controls.dart';

/// A controlled checkbox matching the Penpot Checkbox component.
///
/// Set [onChanged] to null to disable the checkbox. When [tristate] is true,
/// activating the control cycles from false to true to null.
class TsaiCheckbox extends StatelessWidget {
  /// Creates a Tsai checkbox.
  const TsaiCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
    this.label,
    this.description,
    this.labelPosition = TsaiControlLabelPosition.right,
    this.tristate = false,
    this.isError = false,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.semanticLabel,
  }) : assert(tristate || value != null);

  /// Current checked state.
  final bool? value;

  /// Called with the next state, or null when disabled.
  final ValueChanged<bool?>? onChanged;

  /// Optional visible label.
  final String? label;

  /// Optional secondary text below [label].
  final String? description;

  /// Position of the label content.
  final TsaiControlLabelPosition labelPosition;

  /// Whether null is a valid indeterminate state.
  final bool tristate;

  /// Whether to render the unchecked error state.
  final bool isError;

  /// Whether the control requests focus initially.
  final bool autofocus;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Called when keyboard focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Optional accessibility label replacing the visible label.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final checked = value == true;
    final indeterminate = value == null;
    return _TsaiSelectionControl(
      value: checked,
      enabled: onChanged != null,
      label: label,
      description: description,
      labelPosition: labelPosition,
      autofocus: autofocus,
      focusNode: focusNode,
      onFocusChange: onFocusChange,
      semanticLabel: semanticLabel,
      toggledSemanticValue: indeterminate ? 'mixed' : null,
      onActivate: onChanged == null ? null : () => onChanged!(_nextValue()),
      controlBuilder: (context, focused, hovered) {
        final tokens = TsaiThemeTokens.of(context);
        final colors = tokens.colors;
        final enabled = onChanged != null;
        final active = checked || indeterminate;
        final background = enabled
            ? (active ? colors.actionPrimary : colors.surface)
            : colors.surfaceRaised;
        final border = focused
            ? colors.actionPrimarySoft
            : isError && !active
            ? colors.negative
            : enabled
            ? (hovered ? colors.actionPrimarySoft : colors.borderStrong)
            : colors.borderSubtle;
        final iconColor = enabled ? colors.iconOnAction : colors.iconTertiary;
        return AnimatedContainer(
          key: const ValueKey<String>('tsai-checkbox-box'),
          duration: _duration(context, tokens),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(tokens.radii.small),
            border: active && enabled
                ? focused
                      ? Border.all(
                          color: border,
                          width: tokens.borders.hairline * 2,
                        )
                      : null
                : Border.all(
                    color: border,
                    width: focused
                        ? tokens.borders.hairline * 2
                        : tokens.borders.hairline,
                  ),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: _duration(context, tokens),
            child: indeterminate
                ? Icon(
                    LucideIcons.minus,
                    key: const ValueKey<String>('tsai-checkbox-indeterminate'),
                    size: 16,
                    color: iconColor,
                  )
                : checked
                ? Icon(
                    LucideIcons.check,
                    key: const ValueKey<String>('tsai-checkbox-checked'),
                    size: 16,
                    color: iconColor,
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  bool? _nextValue() {
    if (!tristate) {
      return value != true;
    }
    return switch (value) {
      false => true,
      true => null,
      null => false,
    };
  }
}
