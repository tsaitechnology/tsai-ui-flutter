part of '../tsai_input.dart';

/// A text input matching the Penpot Input component.
class TsaiInput extends StatefulWidget {
  /// Creates a Tsai input.
  const TsaiInput({
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
    this.obscureText = false,
    this.showVisibilityButton = false,
    this.showClearButton = true,
    this.trailingAction,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.autofillHints,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    this.onFocusChange,
    this.onCleared,
    this.onObscureChanged,
    this.semanticLabel,
  }) : assert(controller == null || initialValue == null);

  /// Optional caller-owned text controller.
  final TextEditingController? controller;

  /// Initial text used when [controller] is null.
  final String? initialValue;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Text displayed as a placeholder and, when [labeledPlaceholder] is true,
  /// as a floating label while the field is focused or has a value.
  final String? placeholder;

  /// Whether [placeholder] floats above the editable value.
  ///
  /// When false, the placeholder and entered value remain vertically centered.
  final bool labeledPlaceholder;

  /// Supporting text displayed below the field.
  final String? description;

  /// Error text displayed below the field.
  final String? errorText;

  /// Whether the field accepts input.
  final bool enabled;

  /// Whether text can be selected but not changed.
  final bool readOnly;

  /// Whether to hide the value and show a visibility action.
  ///
  /// This is false by default, so ordinary inputs do not show password UI.
  final bool obscureText;

  /// Whether to show an action that toggles value visibility.
  final bool showVisibilityButton;

  /// Whether a non-empty editable value shows a clear action.
  final bool showClearButton;

  /// Optional action displayed at the trailing edge inside the field.
  ///
  /// The Penpot composition uses a medium `TsaiButton`, whose 40-pixel visual
  /// height fits the field with 8 pixels above and below it.
  final Widget? trailingAction;

  /// Whether the input requests focus initially.
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

  /// Called whenever the user changes the value.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the value.
  final ValueChanged<String>? onSubmitted;

  /// Called when editing completes.
  final VoidCallback? onEditingComplete;

  /// Called when the editable value is tapped.
  ///
  /// When [readOnly] is true, this is the plate-wide field action (the whole
  /// 56-pixel control, including trailing chrome). Editable fields still use
  /// the inner text control for caret placement; empty padding focuses the
  /// field through the shared plate hit target.
  final GestureTapCallback? onTap;

  /// Called for a pointer down outside the field's tap region.
  final TapRegionCallback? onTapOutside;

  /// Called when keyboard focus enters or leaves the component.
  final ValueChanged<bool>? onFocusChange;

  /// Called after the clear action removes the value.
  final VoidCallback? onCleared;

  /// Called when the password visibility action changes obscuring.
  final ValueChanged<bool>? onObscureChanged;

  /// Optional accessibility label for the editable value.
  final String? semanticLabel;

  @override
  State<TsaiInput> createState() => _TsaiInputState();
}

class _TsaiInputState extends State<TsaiInput> {
  TextEditingController? _internalController;
  FocusNode? _internalFocusNode;
  bool _focused = false;
  bool _hovered = false;
  late bool _obscured = widget.obscureText;

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
  void didUpdateWidget(covariant TsaiInput oldWidget) {
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
    if (oldWidget.obscureText != widget.obscureText) {
      _obscured = widget.obscureText;
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
    final editable = widget.enabled && !widget.readOnly;
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
          child: _TsaiInputFrame(
            focused: _focused,
            hovered: _hovered,
            enabled: widget.enabled,
            hasError: widget.errorText != null,
            description: widget.description,
            errorText: widget.errorText,
            onFieldTap: widget.enabled ? _handlePlateTap : null,
            actions: [
              if (_controller.text.isNotEmpty &&
                  widget.showClearButton &&
                  editable)
                _InputAction(
                  key: const ValueKey<String>('tsai-input-clear'),
                  icon: const TsaiIcon(LucideIcons.x, size: 16),
                  tooltip: 'Clear',
                  onPressed: _clear,
                ),
              if (widget.showVisibilityButton)
                _InputAction(
                  key: const ValueKey<String>('tsai-input-visibility'),
                  icon: TsaiIcon(
                    _obscured ? LucideIcons.eye_off : LucideIcons.eye,
                    size: 16,
                  ),
                  tooltip: _obscured ? 'Show value' : 'Hide value',
                  onPressed: widget.enabled ? _toggleObscured : null,
                ),
              if (widget.trailingAction case final action?)
                KeyedSubtree(
                  key: const ValueKey<String>('tsai-input-trailing-action'),
                  child: action,
                ),
            ],
            content: _AnimatedInputContent(
              placeholder: widget.placeholder,
              placeholderVisible:
                  _controller.text.isEmpty ||
                  (widget.labeledPlaceholder && widget.placeholder != null),
              floating: floating,
              labelColor: _labelColor(tokens),
              child: MergeSemantics(
                child: SizedBox(
                  height: 48,
                  child: AnimatedAlign(
                    duration: _placeholderDuration(context, tokens),
                    curve: tokens.motion.transitionCurve,
                    alignment: floating
                        ? const AlignmentDirectional(-1, 0.45)
                        : AlignmentDirectional.centerStart,
                    child: SizedBox(
                      height: 20,
                      child: IgnorePointer(
                        ignoring: _opensOverlay,
                        child: TextField(
                          key: const ValueKey<String>('tsai-input-editable'),
                          controller: _controller,
                          focusNode: _focusNode,
                          enabled: widget.enabled,
                          readOnly: widget.readOnly,
                          enableInteractiveSelection: !widget.readOnly,
                          obscureText: _obscured,
                          obscuringCharacter: '•',
                          autofocus: widget.autofocus,
                          keyboardType: widget.keyboardType,
                          textInputAction: widget.textInputAction,
                          textCapitalization: widget.textCapitalization,
                          inputFormatters: [
                            ...?widget.inputFormatters,
                            if (widget.maxLength != null)
                              LengthLimitingTextInputFormatter(
                                widget.maxLength,
                              ),
                          ],
                          autofillHints: widget.autofillHints,
                          maxLines: 1,
                          cursorHeight: 20,
                          cursorColor: colors.actionPrimarySoft,
                          style: tokens.typography.bodyLarge.copyWith(
                            color: widget.enabled
                                ? colors.contentPrimary
                                : colors.contentTertiary,
                          ),
                          decoration: const InputDecoration.collapsed(
                            hintText: '',
                          ),
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          onEditingComplete: widget.onEditingComplete,
                          onTap: _opensOverlay ? null : widget.onTap,
                          onTapOutside: widget.onTapOutside,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
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

  bool get _opensOverlay => widget.readOnly && widget.onTap != null;

  void _handlePlateTap() {
    if (_opensOverlay) {
      widget.onTap!.call();
      return;
    }
    _focusNode.requestFocus();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    widget.onCleared?.call();
    _focusNode.requestFocus();
  }

  void _toggleObscured() {
    setState(() => _obscured = !_obscured);
    widget.onObscureChanged?.call(_obscured);
  }
}
