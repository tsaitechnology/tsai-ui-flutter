import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// A one-time-password input rendered as Penpot OTP cells.
class TsaiOtpInput extends StatelessWidget {
  /// Creates a Tsai OTP input.
  const TsaiOtpInput({
    super.key,
    this.controller,
    this.initialValue,
    this.length = 4,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.isError = false,
    this.isSuccess = false,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onFocusChange,
    this.semanticLabel = 'One-time password',
  }) : assert(controller == null || initialValue == null),
       assert(length > 0),
       assert(!isError || !isSuccess);

  /// Optional caller-owned controller containing digits only.
  final TextEditingController? controller;

  /// Initial digits used when [controller] is null.
  final String? initialValue;

  /// Number of cells. Cells are 56 pixels when space permits.
  final int length;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Whether the sequence accepts input.
  final bool enabled;

  /// Whether the input requests focus initially.
  final bool autofocus;

  /// Whether every cell uses the error border.
  final bool isError;

  /// Whether every cell uses the success border.
  final bool isSuccess;

  /// Called whenever the user changes the sequence.
  final ValueChanged<String>? onChanged;

  /// Called when all cells are filled with a new complete sequence.
  final ValueChanged<String>? onCompleted;

  /// Called when the user submits the sequence.
  final ValueChanged<String>? onSubmitted;

  /// Called when keyboard focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Accessibility label for the editable sequence.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => _TsaiCodeInput(
    kind: _CodeInputKind.otp,
    controller: controller,
    initialValue: initialValue,
    length: length,
    focusNode: focusNode,
    enabled: enabled,
    autofocus: autofocus,
    isError: isError,
    isSuccess: isSuccess,
    onChanged: onChanged,
    onCompleted: onCompleted,
    onSubmitted: onSubmitted,
    onFocusChange: onFocusChange,
    semanticLabel: semanticLabel,
  );
}

/// A PIN input rendered as Penpot PIN dots.
class TsaiPinInput extends StatelessWidget {
  /// Creates a Tsai PIN input.
  const TsaiPinInput({
    super.key,
    this.controller,
    this.initialValue,
    this.length = 4,
    this.focusNode,
    this.enabled = true,
    this.autofocus = false,
    this.isError = false,
    this.isSuccess = false,
    this.onChanged,
    this.onCompleted,
    this.onSubmitted,
    this.onFocusChange,
    this.semanticLabel = 'PIN',
  }) : assert(controller == null || initialValue == null),
       assert(length > 0),
       assert(!isError || !isSuccess);

  /// Optional caller-owned controller containing digits only.
  final TextEditingController? controller;

  /// Initial digits used when [controller] is null.
  final String? initialValue;

  /// Number of 12-pixel dots.
  final int length;

  /// Optional caller-owned focus node.
  final FocusNode? focusNode;

  /// Whether the sequence accepts input.
  final bool enabled;

  /// Whether the input requests focus initially.
  final bool autofocus;

  /// Whether every dot uses the error color.
  final bool isError;

  /// Whether every dot uses the success color.
  final bool isSuccess;

  /// Called whenever the user changes the sequence.
  final ValueChanged<String>? onChanged;

  /// Called when every dot is filled with a new complete sequence.
  final ValueChanged<String>? onCompleted;

  /// Called when the user submits the sequence.
  final ValueChanged<String>? onSubmitted;

  /// Called when keyboard focus changes.
  final ValueChanged<bool>? onFocusChange;

  /// Accessibility label for the editable sequence.
  final String semanticLabel;

  @override
  Widget build(BuildContext context) => _TsaiCodeInput(
    kind: _CodeInputKind.pin,
    controller: controller,
    initialValue: initialValue,
    length: length,
    focusNode: focusNode,
    enabled: enabled,
    autofocus: autofocus,
    isError: isError,
    isSuccess: isSuccess,
    onChanged: onChanged,
    onCompleted: onCompleted,
    onSubmitted: onSubmitted,
    onFocusChange: onFocusChange,
    semanticLabel: semanticLabel,
  );
}

enum _CodeInputKind { otp, pin }

class _TsaiCodeInput extends StatefulWidget {
  const _TsaiCodeInput({
    required this.kind,
    required this.controller,
    required this.initialValue,
    required this.length,
    required this.focusNode,
    required this.enabled,
    required this.autofocus,
    required this.isError,
    required this.isSuccess,
    required this.onChanged,
    required this.onCompleted,
    required this.onSubmitted,
    required this.onFocusChange,
    required this.semanticLabel,
  });

  final _CodeInputKind kind;
  final TextEditingController? controller;
  final String? initialValue;
  final int length;
  final FocusNode? focusNode;
  final bool enabled;
  final bool autofocus;
  final bool isError;
  final bool isSuccess;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<bool>? onFocusChange;
  final String semanticLabel;

  @override
  State<_TsaiCodeInput> createState() => _TsaiCodeInputState();
}

class _TsaiCodeInputState extends State<_TsaiCodeInput> {
  TextEditingController? _internalController;
  bool _focused = false;
  String? _lastCompleted;

  TextEditingController get _controller =>
      widget.controller ??
      (_internalController ??= TextEditingController(
        text: _digits(widget.initialValue ?? '').substring(
          0,
          _digits(widget.initialValue ?? '').length.clamp(0, widget.length),
        ),
      ));

  @override
  void initState() {
    super.initState();
    _normalizeController();
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _TsaiCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _internalController)?.removeListener(
        _handleControllerChanged,
      );
      _internalController?.dispose();
      _internalController = null;
      _normalizeController();
      _controller.addListener(_handleControllerChanged);
    }
    if (oldWidget.length != widget.length) {
      _normalizeController();
      _lastCompleted = null;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final visual = widget.kind == _CodeInputKind.otp
          ? _buildOtp(context, maxWidth: constraints.maxWidth)
          : _buildPin(context);
      return Focus(
        onFocusChange: (value) {
          if (_focused == value) {
            return;
          }
          setState(() => _focused = value);
          widget.onFocusChange?.call(value);
        },
        child: Stack(
          key: ValueKey<String>('tsai-${widget.kind.name}-layout'),
          alignment: Alignment.center,
          children: [
            IgnorePointer(child: visual),
            Positioned.fill(
              child: Semantics(
                label: widget.semanticLabel,
                textField: true,
                enabled: widget.enabled,
                value: '${_controller.text.length} of ${widget.length} digits',
                child: TextField(
                  key: ValueKey<String>('tsai-${widget.kind.name}-editable'),
                  controller: _controller,
                  focusNode: widget.focusNode,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(widget.length),
                  ],
                  autofillHints: widget.kind == _CodeInputKind.otp
                      ? const [AutofillHints.oneTimeCode]
                      : null,
                  obscureText: widget.kind == _CodeInputKind.pin,
                  enableInteractiveSelection: false,
                  showCursor: false,
                  style: const TextStyle(
                    color: Colors.transparent,
                    fontSize: 1,
                  ),
                  cursorColor: Colors.transparent,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  onChanged: _handleChanged,
                  onSubmitted: widget.onSubmitted,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  Widget _buildOtp(BuildContext context, {required double maxWidth}) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final value = _controller.text;
    final activeIndex = value.length >= widget.length
        ? widget.length - 1
        : value.length;
    final gap = tokens.spacing.space8;
    final availableForCells = maxWidth.isFinite
        ? maxWidth - gap * math.max(0, widget.length - 1)
        : 56.0 * widget.length;
    final cellSize = math.min(
      56.0,
      math.max(32.0, availableForCells / widget.length),
    );
    return Row(
      key: const ValueKey<String>('tsai-otp-cells'),
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < widget.length; index++) ...[
          if (index > 0) SizedBox(width: gap),
          SizedBox(
            width: cellSize,
            height: cellSize,
            child: AnimatedContainer(
              key: ValueKey<int>(index),
              duration: _duration(context, tokens),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: widget.enabled ? colors.surface : colors.surfaceRaised,
                borderRadius: BorderRadius.circular(tokens.radii.medium),
                border: Border.all(
                  color: _otpBorderColor(
                    tokens,
                    active: _focused && index == activeIndex,
                  ),
                  width: _focused && index == activeIndex ? 2 : 1,
                ),
              ),
              child: index < value.length
                  ? Text(
                      value[index],
                      style: tokens.typography.monoHeadingLarge.copyWith(
                        color: widget.enabled
                            ? colors.contentPrimary
                            : colors.contentTertiary,
                      ),
                    )
                  : _focused && index == activeIndex
                  ? Container(
                      key: const ValueKey<String>('tsai-otp-cursor'),
                      width: 2,
                      height: math.min(24, cellSize * 0.5),
                      color: colors.actionPrimarySoft,
                    )
                  : null,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPin(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final width =
        widget.length * 12 +
        math.max(0, widget.length - 1) * tokens.spacing.space16;
    return SizedBox(
      width: math.max(48, width),
      height: 48,
      child: Center(
        child: Row(
          key: const ValueKey<String>('tsai-pin-dots'),
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var index = 0; index < widget.length; index++) ...[
              if (index > 0) SizedBox(width: tokens.spacing.space16),
              AnimatedContainer(
                key: ValueKey<int>(index),
                duration: _duration(context, tokens),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: _pinColor(
                    tokens,
                    filled: index < _controller.text.length,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _otpBorderColor(TsaiThemeTokens tokens, {required bool active}) {
    if (widget.isError) {
      return tokens.colors.negative;
    }
    if (widget.isSuccess) {
      return tokens.colors.positive;
    }
    if (active) {
      return tokens.colors.actionPrimarySoft;
    }
    return tokens.colors.borderSubtle;
  }

  Color _pinColor(TsaiThemeTokens tokens, {required bool filled}) {
    if (!widget.enabled) {
      return tokens.colors.contentTertiary;
    }
    if (widget.isError) {
      return tokens.colors.negative;
    }
    if (widget.isSuccess) {
      return tokens.colors.positive;
    }
    return filled ? tokens.colors.iconBright : tokens.colors.borderSubtle;
  }

  void _normalizeController() {
    final controller = _controller;
    var value = _digits(controller.text);
    if (value.length > widget.length) {
      value = value.substring(0, widget.length);
    }
    if (value != controller.text) {
      controller.value = TextEditingValue(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length && value != _lastCompleted) {
      _lastCompleted = value;
      widget.onCompleted?.call(value);
    } else if (value.length != widget.length) {
      _lastCompleted = null;
    }
  }
}

String _digits(String value) => value.replaceAll(RegExp('[^0-9]'), '');

Duration _duration(BuildContext context, TsaiThemeTokens tokens) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : tokens.motion.interaction;
