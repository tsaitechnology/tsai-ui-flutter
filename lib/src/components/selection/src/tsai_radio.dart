part of '../tsai_selection_controls.dart';

/// A controlled radio button matching the Penpot Radio component.
class TsaiRadio<T> extends StatelessWidget {
  /// Creates a Tsai radio button.
  const TsaiRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
    this.label,
    this.description,
    this.labelPosition = TsaiControlLabelPosition.right,
    this.isError = false,
    this.autofocus = false,
    this.focusNode,
    this.onFocusChange,
    this.semanticLabel,
  });

  /// Value represented by this radio button.
  final T value;

  /// Currently selected group value.
  final T? groupValue;

  /// Called when this value is selected, or null when disabled.
  final ValueChanged<T?>? onChanged;

  /// Optional visible label.
  final String? label;

  /// Optional secondary text below [label].
  final String? description;

  /// Position of the label content.
  final TsaiControlLabelPosition labelPosition;

  /// Whether to render the unselected error state.
  final bool isError;

  /// Whether the control requests focus initially.
  final bool autofocus;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Called when keyboard focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Optional accessibility label replacing the visible label.
  final String? semanticLabel;

  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) => _TsaiSelectionControl(
    value: _selected,
    enabled: onChanged != null,
    label: label,
    description: description,
    labelPosition: labelPosition,
    autofocus: autofocus,
    focusNode: focusNode,
    onFocusChange: onFocusChange,
    semanticLabel: semanticLabel,
    mutuallyExclusive: true,
    onActivate: onChanged == null ? null : () => onChanged!(value),
    controlBuilder: (context, focused, hovered) {
      final tokens = TsaiThemeTokens.of(context);
      final colors = tokens.colors;
      final enabled = onChanged != null;
      final background = enabled
          ? (_selected ? colors.actionPrimary : colors.surface)
          : colors.surfaceRaised;
      final border = focused
          ? colors.actionPrimarySoft
          : isError && !_selected
          ? colors.accentError
          : enabled
          ? (hovered ? colors.actionPrimarySoft : colors.borderStrong)
          : colors.borderSubtle;
      final dotColor = enabled ? colors.iconOnAction : colors.iconTertiary;
      return AnimatedContainer(
        key: const ValueKey<String>('tsai-radio-box'),
        duration: _duration(context, tokens),
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: background,
          shape: BoxShape.circle,
          border: _selected && enabled && !focused
              ? null
              : Border.all(
                  color: border,
                  width: focused
                      ? tokens.borders.hairline * 2
                      : tokens.borders.hairline,
                ),
        ),
        alignment: Alignment.center,
        child: AnimatedScale(
          duration: _duration(context, tokens),
          scale: _selected ? 1 : 0,
          child: Container(
            key: const ValueKey<String>('tsai-radio-dot'),
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
        ),
      );
    },
  );
}
