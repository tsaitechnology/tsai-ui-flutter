import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// Position of the label relative to a Tsai selection control.
enum TsaiControlLabelPosition {
  /// Places the label before the control.
  left,

  /// Places the label after the control.
  right,
}

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
                      ? Border.all(color: border, width: 2)
                      : null
                : Border.all(
                    color: border,
                    width: focused ? 2 : tokens.borders.hairline,
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
          ? colors.negative
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
                  width: focused ? 2 : tokens.borders.hairline,
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
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(tokens.radii.pill),
          border: value && enabled && !focused
              ? null
              : Border.all(
                  color: border,
                  width: focused ? 2 : tokens.borders.hairline,
                ),
        ),
        child: AnimatedAlign(
          duration: _duration(context, tokens),
          curve: Curves.easeOut,
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

typedef _ControlBuilder =
    Widget Function(BuildContext context, bool focused, bool hovered);

class _TsaiSelectionControl extends StatefulWidget {
  const _TsaiSelectionControl({
    required this.value,
    required this.enabled,
    required this.label,
    required this.description,
    required this.labelPosition,
    required this.autofocus,
    required this.focusNode,
    required this.onFocusChange,
    required this.semanticLabel,
    required this.onActivate,
    required this.controlBuilder,
    this.mutuallyExclusive = false,
    this.isSwitch = false,
    this.toggledSemanticValue,
  });

  final bool value;
  final bool enabled;
  final String? label;
  final String? description;
  final TsaiControlLabelPosition labelPosition;
  final bool autofocus;
  final FocusNode? focusNode;
  final ValueChanged<bool>? onFocusChange;
  final String? semanticLabel;
  final VoidCallback? onActivate;
  final _ControlBuilder controlBuilder;
  final bool mutuallyExclusive;
  final bool isSwitch;
  final String? toggledSemanticValue;

  @override
  State<_TsaiSelectionControl> createState() => _TsaiSelectionControlState();
}

class _TsaiSelectionControlState extends State<_TsaiSelectionControl> {
  bool _focused = false;
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final control = widget.controlBuilder(context, _focused, _hovered);
    final content = widget.label == null && widget.description == null
        ? null
        : _SelectionContent(
            label: widget.label,
            description: widget.description,
            enabled: widget.enabled,
          );
    final row = LayoutBuilder(
      builder: (context, constraints) => Row(
        key: const ValueKey<String>('tsai-selection-row'),
        mainAxisSize: constraints.hasBoundedWidth
            ? MainAxisSize.max
            : MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.labelPosition == TsaiControlLabelPosition.right
            ? [
                control,
                if (content != null) ...[
                  SizedBox(width: tokens.spacing.space8),
                  Flexible(child: content),
                ],
              ]
            : [
                if (content != null) ...[
                  Flexible(child: content),
                  SizedBox(width: tokens.spacing.space8),
                ],
                control,
              ],
      ),
    );
    return Semantics(
      container: true,
      enabled: widget.enabled,
      checked: widget.isSwitch ? null : widget.value,
      toggled: widget.isSwitch ? widget.value : null,
      inMutuallyExclusiveGroup: widget.mutuallyExclusive,
      label: widget.semanticLabel ?? widget.label,
      value: widget.toggledSemanticValue,
      onTap: widget.enabled ? widget.onActivate : null,
      excludeSemantics: true,
      child: FocusableActionDetector(
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        focusNode: widget.focusNode,
        mouseCursor: widget.enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onFocusChange: (value) {
          if (_focused == value) {
            return;
          }
          setState(() => _focused = value);
          widget.onFocusChange?.call(value);
        },
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onActivate?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? widget.onActivate : null,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: row,
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionContent extends StatelessWidget {
  const _SelectionContent({
    required this.label,
    required this.description,
    required this.enabled,
  });

  final String? label;
  final String? description;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final color = enabled
        ? tokens.colors.contentPrimary
        : tokens.colors.contentTertiary;
    return Padding(
      padding: EdgeInsets.only(top: tokens.spacing.space2),
      child: Column(
        key: const ValueKey<String>('tsai-selection-content'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(
              label!,
              style: tokens.typography.bodyMedium.copyWith(color: color),
            ),
          if (description != null) ...[
            SizedBox(height: tokens.spacing.space2),
            Text(
              description!,
              style: tokens.typography.captionMediumRegular.copyWith(
                color: enabled
                    ? tokens.colors.contentSecondary
                    : tokens.colors.contentTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

Duration _duration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction;
