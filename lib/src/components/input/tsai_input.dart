import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A text input matching the Penpot Input component.
class TsaiInput extends StatefulWidget {
  /// Creates a Tsai input.
  const TsaiInput({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hintText,
    this.description,
    this.errorText,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.showVisibilityButton = false,
    this.showClearButton = true,
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

  /// Label displayed above the value inside the field.
  final String? label;

  /// Placeholder displayed while the field is empty.
  final String? hintText;

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
  ///
  /// This is false by default. [obscureText] also enables the action for
  /// backwards-compatible password input behavior.
  final bool showVisibilityButton;

  /// Whether a non-empty editable value shows a clear action.
  final bool showClearButton;

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
          explicitChildNodes: true,
          label: widget.semanticLabel ?? widget.label,
          child: _TsaiInputFrame(
            focused: _focused,
            hovered: _hovered,
            enabled: widget.enabled,
            hasError: widget.errorText != null,
            description: widget.description,
            errorText: widget.errorText,
            actions: [
              if (_controller.text.isNotEmpty &&
                  widget.showClearButton &&
                  editable)
                _InputAction(
                  key: const ValueKey<String>('tsai-input-clear'),
                  icon: LucideIcons.x,
                  tooltip: 'Clear',
                  onPressed: _clear,
                ),
              if (widget.obscureText || widget.showVisibilityButton)
                _InputAction(
                  key: const ValueKey<String>('tsai-input-visibility'),
                  icon: _obscured ? LucideIcons.eye_off : LucideIcons.eye,
                  tooltip: _obscured ? 'Show value' : 'Hide value',
                  onPressed: widget.enabled ? _toggleObscured : null,
                ),
            ],
            content: _InputContent(
              label: widget.label,
              labelColor: _labelColor(tokens),
              child: SizedBox(
                height: 20,
                child: TextField(
                  key: const ValueKey<String>('tsai-input-editable'),
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  readOnly: widget.readOnly,
                  obscureText: _obscured,
                  obscuringCharacter: '•',
                  autofocus: widget.autofocus,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  textCapitalization: widget.textCapitalization,
                  inputFormatters: [
                    ...?widget.inputFormatters,
                    if (widget.maxLength != null)
                      LengthLimitingTextInputFormatter(widget.maxLength),
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
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hintText,
                    hintStyle: tokens.typography.bodyLarge.copyWith(
                      color: colors.contentTertiary,
                    ),
                  ),
                  onChanged: widget.onChanged,
                  onSubmitted: widget.onSubmitted,
                  onEditingComplete: widget.onEditingComplete,
                  onTap: widget.onTap,
                  onTapOutside: widget.onTapOutside,
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

/// Formats a national phone number with a digit mask.
///
/// Each `#` in [mask] accepts one digit. Separators are inserted only between
/// entered digits. Deleting a separator also deletes the adjacent digit in the
/// direction of the edit, preventing the cursor from becoming stuck.
class TsaiPhoneInputFormatter extends TextInputFormatter {
  /// Creates a phone formatter.
  TsaiPhoneInputFormatter({this.mask = '### ### ## ##'})
    : assert(mask.contains('#')),
      maxDigits = '#'.allMatches(mask).length;

  /// Mask whose `#` characters represent digits.
  final String mask;

  /// Maximum digit count accepted by [mask].
  final int maxDigits;

  /// Returns only decimal digits from [value].
  static String digitsOf(String value) =>
      value.replaceAll(RegExp('[^0-9]'), '');

  /// Formats raw or partially formatted digits with [mask].
  String format(String value) => _formatDigits(
    digitsOf(value).substring(0, math.min(digitsOf(value).length, maxDigits)),
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = digitsOf(newValue.text);
    var baseDigitOffset = _digitsBefore(
      newValue.text,
      newValue.selection.baseOffset,
    );
    var extentDigitOffset = _digitsBefore(
      newValue.text,
      newValue.selection.extentOffset,
    );
    final oldDigits = digitsOf(oldValue.text);
    final removedOnlySeparator =
        newValue.text.length < oldValue.text.length &&
        digits == oldDigits &&
        oldValue.selection.isCollapsed &&
        newValue.selection.isCollapsed;
    if (removedOnlySeparator && digits.isNotEmpty) {
      final isBackspace =
          newValue.selection.extentOffset < oldValue.selection.extentOffset;
      final removalIndex = isBackspace ? baseDigitOffset - 1 : baseDigitOffset;
      if (removalIndex >= 0 && removalIndex < digits.length) {
        digits =
            digits.substring(0, removalIndex) +
            digits.substring(removalIndex + 1);
        baseDigitOffset = math.min(baseDigitOffset, digits.length);
        extentDigitOffset = math.min(extentDigitOffset, digits.length);
      }
    }
    if (digits.length > maxDigits) {
      digits = digits.substring(0, maxDigits);
    }
    baseDigitOffset = math.min(baseDigitOffset, digits.length);
    extentDigitOffset = math.min(extentDigitOffset, digits.length);
    final formatted = _formatDigits(digits);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection(
        baseOffset: _offsetForDigits(formatted, baseDigitOffset),
        extentOffset: _offsetForDigits(formatted, extentDigitOffset),
        affinity: newValue.selection.affinity,
        isDirectional: newValue.selection.isDirectional,
      ),
    );
  }

  String _formatDigits(String digits) {
    if (digits.isEmpty) {
      return '';
    }
    final result = StringBuffer();
    var digitIndex = 0;
    for (var maskIndex = 0; maskIndex < mask.length; maskIndex++) {
      final character = mask[maskIndex];
      if (character == '#') {
        if (digitIndex >= digits.length) {
          break;
        }
        result.write(digits[digitIndex++]);
        continue;
      }
      if (digitIndex > 0 && digitIndex < digits.length) {
        result.write(character);
      }
    }
    return result.toString();
  }

  static int _digitsBefore(String value, int offset) {
    if (offset <= 0) {
      return 0;
    }
    return digitsOf(value.substring(0, math.min(offset, value.length))).length;
  }

  static int _offsetForDigits(String value, int digitCount) {
    if (digitCount <= 0) {
      return 0;
    }
    var seen = 0;
    for (var index = 0; index < value.length; index++) {
      if (_isDigit(value.codeUnitAt(index))) {
        seen++;
        if (seen == digitCount) {
          return index + 1;
        }
      }
    }
    return value.length;
  }

  static bool _isDigit(int codeUnit) => codeUnit >= 48 && codeUnit <= 57;
}

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
          child: _TsaiInputFrame(
            focused: _focused,
            hovered: _hovered,
            enabled: widget.enabled,
            hasError: widget.errorText != null,
            description: widget.description,
            errorText: widget.errorText,
            actions: [
              if (_controller.text.isNotEmpty &&
                  widget.showClearButton &&
                  editable)
                _InputAction(
                  key: const ValueKey<String>('tsai-phone-clear'),
                  icon: LucideIcons.x,
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
                        AnimatedContainer(
                          duration: _duration(context, tokens),
                          width: math.max(
                            10,
                            _countryController.text.length * 10,
                          ),
                          height: 20,
                          child: TextField(
                            key: const ValueKey<String>(
                              'tsai-phone-country-editable',
                            ),
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
                    Container(
                      key: const ValueKey<String>('tsai-phone-divider'),
                      width: tokens.borders.hairline,
                      height: 16,
                      color: colors.borderSubtle,
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
    _countryController.selection = TextSelection.collapsed(
      offset: _countryController.text.length,
    );
    _countryFocusNode.requestFocus();
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

class _TsaiInputFrame extends StatelessWidget {
  const _TsaiInputFrame({
    required this.content,
    required this.actions,
    required this.focused,
    required this.hovered,
    required this.enabled,
    required this.hasError,
    required this.description,
    required this.errorText,
  });

  final Widget content;
  final List<Widget> actions;
  final bool focused;
  final bool hovered;
  final bool enabled;
  final bool hasError;
  final String? description;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final borderColor = hasError
        ? colors.negative
        : focused
        ? colors.actionPrimarySoft
        : hovered && enabled
        ? colors.borderStrong
        : colors.borderSubtle;
    return Column(
      key: const ValueKey<String>('tsai-input-layout'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          key: const ValueKey<String>('tsai-input-field'),
          duration: _duration(context, tokens),
          height: 56,
          padding: EdgeInsetsDirectional.only(
            start: tokens.spacing.space16,
            end: tokens.spacing.space8,
          ),
          decoration: BoxDecoration(
            color: enabled ? colors.surface : colors.surfaceRaised,
            borderRadius: BorderRadius.circular(tokens.radii.medium),
            border: Border.all(
              color: borderColor,
              width: focused ? 2 : tokens.borders.hairline,
            ),
          ),
          child: Row(
            children: [
              Expanded(child: content),
              if (actions.isNotEmpty)
                Row(
                  key: const ValueKey<String>('tsai-input-actions'),
                  mainAxisSize: MainAxisSize.min,
                  children: actions,
                ),
            ],
          ),
        ),
        if (description != null || errorText != null) ...[
          SizedBox(height: tokens.spacing.space4),
          Padding(
            padding: EdgeInsetsDirectional.only(start: tokens.spacing.space4),
            child: Text(
              errorText ?? description!,
              key: const ValueKey<String>('tsai-input-description'),
              style: tokens.typography.captionMediumRegular.copyWith(
                color: errorText == null
                    ? colors.contentSecondary
                    : colors.negative,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _InputContent extends StatelessWidget {
  const _InputContent({
    required this.label,
    required this.labelColor,
    required this.child,
  });

  final String? label;
  final Color labelColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Column(
      key: const ValueKey<String>('tsai-input-content'),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tokens.typography.captionMediumRegular.copyWith(
              color: labelColor,
            ),
          ),
          SizedBox(height: tokens.spacing.space2),
        ],
        child,
      ],
    );
  }
}

class _InputAction extends StatelessWidget {
  const _InputAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = TsaiThemeTokens.of(context).colors;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 32, height: 32),
      splashRadius: 16,
      icon: Icon(
        icon,
        size: 16,
        color: onPressed == null ? colors.iconTertiary : colors.iconSecondary,
      ),
    );
  }
}

Duration _duration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction;
