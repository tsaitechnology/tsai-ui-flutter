part of '../tsai_input.dart';

/// A phone input matching the Penpot Input Phone component.
///
/// The country calling code and national number are separate editable fields.
/// [controller] contains the formatted national number.
class TsaiPhoneInput extends StatefulWidget {
  /// Creates a Tsai phone input.
  const TsaiPhoneInput({
    super.key,
    this.controller,
    this.countryCodeController,
    this.initialValue,
    this.initialCountryCode = '1',
    this.focusNode,
    this.label = 'Phone number',
    this.description,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.showClearButton = true,
    this.autofocus = false,
    this.mask = '### ### ## ##',
    this.textInputAction,
    this.autofillHints = const [AutofillHints.telephoneNumberNational],
    this.onChanged,
    this.onCountryCodeChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onFocusChange,
    this.onCleared,
    this.semanticLabel,
  }) : assert(controller == null || initialValue == null),
       assert(
         countryCodeController == null || initialCountryCode == '1',
         'Do not provide initialCountryCode with countryCodeController.',
       );

  /// Optional caller-owned national-number controller.
  final TextEditingController? controller;

  /// Optional caller-owned country-code controller.
  final TextEditingController? countryCodeController;

  /// Initial national number used when [controller] is null.
  final String? initialValue;

  /// Initial digits after `+` when [countryCodeController] is null.
  final String initialCountryCode;

  /// Focus node for the national-number field.
  final FocusNode? focusNode;

  /// Label displayed inside the field.
  final String? label;

  /// Supporting text below the field.
  final String? description;

  /// Error text below the field.
  final String? errorText;

  /// Whether both editable parts accept input.
  final bool enabled;

  /// Whether values can be selected but not changed.
  final bool readOnly;

  /// Whether a non-empty number shows a clear action.
  final bool showClearButton;

  /// Whether the national-number field requests focus initially.
  final bool autofocus;

  /// National-number mask using `#` digit placeholders.
  final String mask;

  /// IME action for the national-number field.
  final TextInputAction? textInputAction;

  /// Autofill hints for the national-number field.
  final Iterable<String>? autofillHints;

  /// Called with the formatted national number after user edits.
  final ValueChanged<String>? onChanged;

  /// Called with country-code digits after user edits.
  final ValueChanged<String>? onCountryCodeChanged;

  /// Called when the national number fills every mask placeholder.
  final ValueChanged<String>? onCompleted;

  /// Called when the user submits the national number.
  final ValueChanged<String>? onSubmitted;

  /// Called when focus enters or leaves either editable part.
  final ValueChanged<bool>? onFocusChange;

  /// Called after the clear action removes the national number.
  final VoidCallback? onCleared;

  /// Optional accessibility label for the component.
  final String? semanticLabel;

  @override
  State<TsaiPhoneInput> createState() => _TsaiPhoneInputState();
}

class _TsaiPhoneInputState extends State<TsaiPhoneInput> {
  TextEditingController? _internalController;
  TextEditingController? _internalCountryController;
  FocusNode? _internalFocusNode;
  final FocusNode _countryFocusNode = FocusNode(
    debugLabel: 'TsaiPhoneInput country code',
    skipTraversal: true,
  );
  final GlobalKey _dividerKey = GlobalKey(debugLabel: 'TsaiPhoneInput divider');
  final Object _tapRegionGroupId = Object();
  late TsaiPhoneInputFormatter _formatter = TsaiPhoneInputFormatter(
    mask: widget.mask,
  );
  bool _focused = false;
  bool _hovered = false;
  String? _lastCompleted;

  TextEditingController get _controller =>
      widget.controller ??
      (_internalController ??= TextEditingController(
        text: _formatter.format(widget.initialValue ?? ''),
      ));

  TextEditingController get _countryController =>
      widget.countryCodeController ??
      (_internalCountryController ??= TextEditingController(
        text: TsaiPhoneInputFormatter.digitsOf(widget.initialCountryCode),
      ));

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _normalizeController();
    _controller.addListener(_handleControllerChanged);
    _countryController.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant TsaiPhoneInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mask != widget.mask) {
      _formatter = TsaiPhoneInputFormatter(mask: widget.mask);
      _normalizeController();
    }
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _handleControllerChanged,
      );
      _internalController?.dispose();
      _internalController = null;
      _normalizeController();
      _controller.addListener(_handleControllerChanged);
    }
    if (oldWidget.countryCodeController != widget.countryCodeController) {
      (oldWidget.countryCodeController ?? _internalCountryController)
          ?.removeListener(_handleControllerChanged);
      _internalCountryController?.dispose();
      _internalCountryController = null;
      _countryController.addListener(_handleControllerChanged);
    }
    if (oldWidget.focusNode != widget.focusNode && widget.focusNode != null) {
      _internalFocusNode?.dispose();
      _internalFocusNode = null;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _countryController.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    _internalCountryController?.dispose();
    _internalFocusNode?.dispose();
    _countryFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final editable = widget.enabled && !widget.readOnly;
    final placeholder = widget.mask.replaceAll('#', '0');
    final countryCodeWidth = _textWidth(
      context,
      _countryController.text,
      tokens.typography.bodyLarge,
    );
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Focus(
        canRequestFocus: false,
        onFocusChange: (value) {
          if (_focused == value) {
            return;
          }
          setState(() => _focused = value);
          widget.onFocusChange?.call(value);
        },
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          label: widget.semanticLabel ?? widget.label,
          child: TextFieldTapRegion(
            groupId: _tapRegionGroupId,
            child: _TsaiInputFrame(
              focused: _focused,
              hovered: _hovered,
              enabled: widget.enabled,
              hasError: widget.errorText != null,
              description: widget.description,
              errorText: widget.errorText,
              onFieldTap: null,
              onFieldPointerDown: widget.enabled
                  ? _handleFieldPointerDown
                  : null,
              actions: [
                if (_controller.text.isNotEmpty &&
                    widget.showClearButton &&
                    editable)
                  _InputAction(
                    key: const ValueKey<String>('tsai-phone-clear'),
                    icon: const TsaiIcon(LucideIcons.x, size: 16),
                    tooltip: 'Clear phone number',
                    onPressed: _clear,
                  ),
              ],
              content: _InputContent(
                label: widget.label,
                labelColor: _labelColor(tokens),
                child: SizedBox(
                  height: 20,
                  child: Row(
                    key: const ValueKey<String>('tsai-phone-row'),
                    children: [
                      Row(
                        key: const ValueKey<String>('tsai-phone-country'),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '+',
                            style: tokens.typography.bodyLarge.copyWith(
                              color: widget.enabled
                                  ? colors.contentPrimary
                                  : colors.contentTertiary,
                            ),
                          ),
                          SizedBox(
                            key: const ValueKey<String>(
                              'tsai-phone-country-width',
                            ),
                            width: countryCodeWidth,
                            height: 20,
                            child: TextField(
                              key: const ValueKey<String>(
                                'tsai-phone-country-editable',
                              ),
                              groupId: _tapRegionGroupId,
                              controller: _countryController,
                              focusNode: _countryFocusNode,
                              enabled: widget.enabled,
                              readOnly: widget.readOnly,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
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
                              onChanged: widget.onCountryCodeChanged,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: tokens.spacing.space8),
                      KeyedSubtree(
                        key: const ValueKey<String>('tsai-phone-divider'),
                        child: Container(
                          key: _dividerKey,
                          width: tokens.borders.hairline,
                          height: 16,
                          color: colors.borderSubtle,
                        ),
                      ),
                      SizedBox(width: tokens.spacing.space8),
                      Expanded(
                        child: Focus(
                          canRequestFocus: false,
                          onKeyEvent: _handleNationalKeyEvent,
                          child: TextField(
                            key: const ValueKey<String>(
                              'tsai-phone-value-editable',
                            ),
                            groupId: _tapRegionGroupId,
                            controller: _controller,
                            focusNode: _focusNode,
                            enabled: widget.enabled,
                            readOnly: widget.readOnly,
                            autofocus: widget.autofocus,
                            keyboardType: TextInputType.phone,
                            textInputAction: widget.textInputAction,
                            inputFormatters: [_formatter],
                            autofillHints: widget.autofillHints,
                            maxLines: 1,
                            cursorHeight: 20,
                            cursorColor: colors.actionPrimarySoft,
                            style: tokens.typography.bodyLarge.copyWith(
                              color: widget.enabled
                                  ? colors.contentPrimary
                                  : colors.contentTertiary,
                            ),
                            decoration: InputDecoration.collapsed(
                              hintText: placeholder,
                              hintStyle: tokens.typography.bodyLarge.copyWith(
                                color: colors.contentTertiary,
                              ),
                            ),
                            onChanged: _handlePhoneChanged,
                            onSubmitted: widget.onSubmitted,
                          ),
                        ),
                      ),
                    ],
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
      return tokens.colors.negative;
    }
    return tokens.colors.contentSecondary;
  }

  void _focusCountryCode() {
    _countryController.selection = TextSelection.collapsed(
      offset: _countryController.text.length,
    );
    _countryFocusNode.requestFocus();
  }

  void _handleFieldPointerDown(PointerDownEvent event) {
    final dividerBox =
        _dividerKey.currentContext?.findRenderObject() as RenderBox?;
    if (dividerBox == null || !dividerBox.hasSize) {
      return;
    }
    final dividerCenter = dividerBox.localToGlobal(
      Offset(dividerBox.size.width / 2, dividerBox.size.height / 2),
    );
    final countryTapped = switch (Directionality.of(context)) {
      TextDirection.ltr => event.position.dx < dividerCenter.dx,
      TextDirection.rtl => event.position.dx > dividerCenter.dx,
    };
    if (countryTapped) {
      _focusCountryCode();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _normalizeController() {
    final controller = _controller;
    final formatted = _formatter.format(controller.text);
    if (formatted != controller.text) {
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handlePhoneChanged(String value) {
    widget.onChanged?.call(value);
    final complete =
        TsaiPhoneInputFormatter.digitsOf(value).length == _formatter.maxDigits;
    if (complete && value != _lastCompleted) {
      _lastCompleted = value;
      widget.onCompleted?.call(value);
    } else if (!complete) {
      _lastCompleted = null;
    }
  }

  KeyEventResult _handleNationalKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.backspace ||
        !widget.enabled ||
        widget.readOnly ||
        _controller.text.isNotEmpty ||
        !_controller.selection.isCollapsed ||
        _controller.selection.extentOffset != 0) {
      return KeyEventResult.ignored;
    }
    _focusCountryCode();
    return KeyEventResult.handled;
  }

  void _clear() {
    _controller.clear();
    _lastCompleted = null;
    widget.onChanged?.call('');
    widget.onCleared?.call();
    _focusNode.requestFocus();
  }
}
