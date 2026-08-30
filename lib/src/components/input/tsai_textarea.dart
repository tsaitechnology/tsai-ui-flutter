import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

part 'src/tsai_textarea_field.dart';
part 'src/tsai_textarea_meta.dart';

/// Multiline text field matching the Penpot Textarea component.
class TsaiTextarea extends StatefulWidget {
  /// Creates a Tsai textarea.
  const TsaiTextarea({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.placeholder,
    this.labeledPlaceholder = true,
    this.description,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.showCharacterCounter = false,
    this.fieldHeight = 120,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.minLines,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    this.onFocusChange,
    this.semanticLabel,
  }) : assert(controller == null || initialValue == null),
       assert(fieldHeight > 0);

  /// Optional caller-owned text controller.
  final TextEditingController? controller;

  /// Initial text used when [controller] is null.
  final String? initialValue;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Placeholder and, when [labeledPlaceholder] is true, floating label.
  final String? placeholder;

  /// Whether [placeholder] floats above the editable value.
  final bool labeledPlaceholder;

  /// Supporting text on the start of the meta row (`text.secondary`).
  final String? description;

  /// When set, the field uses the Error variant. Helper copy stays
  /// [description] when provided; otherwise this string is shown as the helper
  /// in secondary color. The label, border, and counter use the error color.
  final String? errorText;

  /// Whether the field accepts input.
  final bool enabled;

  /// Whether text can be selected but not changed.
  final bool readOnly;

  /// Whether the `current/max` character counter is shown.
  ///
  /// Hidden by default. Requires [maxLength] to render the Penpot `120/500`
  /// pattern.
  final bool showCharacterCounter;

  /// Fixed height of the field plate. Penpot default is 120; may be stretched.
  final double fieldHeight;

  /// Whether the field requests focus initially.
  final bool autofocus;

  /// Keyboard configuration for the value.
  final TextInputType? keyboardType;

  /// IME action for the value.
  final TextInputAction? textInputAction;

  /// Automatic capitalization behavior.
  final TextCapitalization textCapitalization;

  /// Formatters applied in order to text edits.
  final List<TextInputFormatter>? inputFormatters;

  /// Autofill hints passed to Flutter's text input.
  final Iterable<String>? autofillHints;

  /// Maximum number of characters accepted by the field.
  final int? maxLength;

  /// Minimum visible lines when [fieldHeight] allows wrapping.
  final int? minLines;

  /// Called whenever the user changes the value.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the value.
  final ValueChanged<String>? onSubmitted;

  /// Called when editing completes.
  final VoidCallback? onEditingComplete;

  /// Called when the editable value is tapped.
  final GestureTapCallback? onTap;

  /// Called for a pointer down outside the field's tap region.
  final TapRegionCallback? onTapOutside;

  /// Called when keyboard focus enters or leaves the component.
  final ValueChanged<bool>? onFocusChange;

  /// Optional accessibility label for the editable value.
  final String? semanticLabel;

  @override
  State<TsaiTextarea> createState() => _TsaiTextareaState();
}

class _TsaiTextareaState extends State<TsaiTextarea> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;
  bool _focused = false;
  bool _hovered = false;

  TextEditingController get _controller =>
      widget.controller ??
      (_internalController ??= TextEditingController(
        text: widget.initialValue,
      ));

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant TsaiTextarea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _handleControllerChanged,
      );
      _internalController?.dispose();
      _internalController = null;
      _controller.addListener(_handleControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode && widget.focusNode != null) {
      _internalFocusNode?.dispose();
      _internalFocusNode = null;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final floating =
        widget.labeledPlaceholder &&
        widget.placeholder != null &&
        (_focused || _controller.text.isNotEmpty);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Focus(
        onFocusChange: (value) {
          if (_focused == value) {
            return;
          }
          setState(() => _focused = value);
          widget.onFocusChange?.call(value);
        },
        child: Semantics(
          container: true,
          label: widget.semanticLabel ?? widget.placeholder,
          child: Column(
            key: const ValueKey<String>('tsai-textarea-layout'),
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TsaiTextareaField(
                focused: _focused,
                hovered: _hovered,
                enabled: widget.enabled,
                hasError: widget.errorText != null,
                height: widget.fieldHeight,
                onFieldTap: widget.enabled ? _focusNode.requestFocus : null,
                content: _TsaiTextareaContent(
                  placeholder: widget.placeholder,
                  placeholderVisible:
                      _controller.text.isEmpty ||
                      (widget.labeledPlaceholder && widget.placeholder != null),
                  floating: floating,
                  labelColor: _labelColor(tokens),
                  child: TextField(
                    key: const ValueKey<String>('tsai-textarea-editable'),
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    readOnly: widget.readOnly,
                    autofocus: widget.autofocus,
                    keyboardType:
                        widget.keyboardType ?? TextInputType.multiline,
                    textInputAction: widget.textInputAction,
                    textCapitalization: widget.textCapitalization,
                    inputFormatters: [
                      ...?widget.inputFormatters,
                      if (widget.maxLength != null)
                        LengthLimitingTextInputFormatter(widget.maxLength),
                    ],
                    autofillHints: widget.autofillHints,
                    maxLines: null,
                    minLines: widget.minLines,
                    expands: widget.minLines == null,
                    textAlignVertical: TextAlignVertical.top,
                    cursorColor: colors.actionPrimarySoft,
                    style: tokens.typography.bodyLarge.copyWith(
                      color: widget.enabled
                          ? colors.contentPrimary
                          : colors.contentTertiary,
                    ),
                    decoration: const InputDecoration.collapsed(hintText: ''),
                    buildCounter:
                        (
                          context, {
                          required currentLength,
                          required isFocused,
                          required maxLength,
                        }) => const SizedBox.shrink(),
                    onChanged: widget.onChanged,
                    onSubmitted: widget.onSubmitted,
                    onEditingComplete: widget.onEditingComplete,
                    onTap: widget.onTap,
                    onTapOutside: widget.onTapOutside,
                  ),
                ),
              ),
              TsaiTextareaMetaRow(
                description: widget.description ?? widget.errorText,
                descriptionIsError: false,
                counterText: _counterText,
                counterIsError: widget.errorText != null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? get _counterText {
    if (!widget.showCharacterCounter || widget.maxLength == null) {
      return null;
    }
    return '${_controller.text.length}/${widget.maxLength}';
  }

  Color _labelColor(TsaiThemeTokens tokens) {
    if (!widget.enabled) {
      return tokens.colors.contentTertiary;
    }
    if (widget.errorText != null) {
      return tokens.colors.accentError;
    }
    return tokens.colors.contentSecondary;
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}
