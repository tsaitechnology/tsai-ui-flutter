import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';
import '../../icons/tsai_icon.dart';
import '../typography/tsai_text.dart';

/// Layout of the bottom-left keypad key.
enum TsaiKeypadMode {
  /// Shows a decimal point key.
  decimal,

  /// Hides the decimal key while keeping the grid.
  integer,

  /// Replaces the decimal key with a biometric action.
  pin,
}

/// A 4×3 numeric keypad matching the Penpot Numeric Keypad.
class TsaiNumericKeypad extends StatelessWidget {
  /// Creates a numeric keypad.
  const TsaiNumericKeypad({
    super.key,
    this.mode = TsaiKeypadMode.decimal,
    this.onDigit,
    this.onDecimal,
    this.onBackspace,
    this.onBiometric,
  });

  /// Bottom-left key treatment.
  final TsaiKeypadMode mode;

  /// Called with a digit from `"0"` to `"9"`.
  final ValueChanged<String>? onDigit;

  /// Called when the decimal key is pressed.
  final VoidCallback? onDecimal;

  /// Called when the delete key is pressed.
  final VoidCallback? onBackspace;

  /// Called when the biometric key is pressed in [TsaiKeypadMode.pin].
  final VoidCallback? onBiometric;

  static const _digits = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      key: const ValueKey<String>('tsai-numeric-keypad'),
      width: 358,
      height: 240,
      child: Column(
        children: [
          for (final row in _digits)
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  for (var i = 0; i < row.length; i++) ...[
                    if (i > 0) SizedBox(width: tokens.spacing.space8),
                    Expanded(
                      child: _KeypadKey(
                        onPressed: onDigit == null
                            ? null
                            : () => onDigit!(row[i]),
                        child: TsaiTextMonoHeading(
                          row[i],
                          size: TsaiMonoHeadingSize.large,
                          color: tokens.colors.contentPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(child: _bottomLeading(context)),
                SizedBox(width: tokens.spacing.space8),
                Expanded(
                  child: _KeypadKey(
                    onPressed: onDigit == null ? null : () => onDigit!('0'),
                    child: TsaiTextMonoHeading(
                      '0',
                      size: TsaiMonoHeadingSize.large,
                      color: tokens.colors.contentPrimary,
                    ),
                  ),
                ),
                SizedBox(width: tokens.spacing.space8),
                Expanded(
                  child: _KeypadKey(
                    semanticLabel: 'Delete',
                    onPressed: onBackspace,
                    child: TsaiIcon(
                      LucideIcons.delete,
                      size: tokens.spacing.space24,
                      color: tokens.colors.iconPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomLeading(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return switch (mode) {
      TsaiKeypadMode.integer => const _KeypadKey(child: SizedBox.shrink()),
      TsaiKeypadMode.decimal => _KeypadKey(
        onPressed: onDecimal,
        child: TsaiTextMonoHeading(
          '.',
          size: TsaiMonoHeadingSize.large,
          color: tokens.colors.contentPrimary,
        ),
      ),
      TsaiKeypadMode.pin => _KeypadKey(
        semanticLabel: 'Biometric unlock',
        onPressed: onBiometric,
        child: TsaiIcon(
          LucideIcons.fingerprint_pattern,
          size: tokens.spacing.space24,
          color: tokens.colors.iconPrimary,
        ),
      ),
    };
  }
}

class _KeypadKey extends StatefulWidget {
  const _KeypadKey({required this.child, this.onPressed, this.semanticLabel});

  final Widget child;
  final VoidCallback? onPressed;
  final String? semanticLabel;

  @override
  State<_KeypadKey> createState() => _KeypadKeyState();
}

class _KeypadKeyState extends State<_KeypadKey> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final key = AnimatedContainer(
      duration: tokens.motion.interaction,
      curve: tokens.motion.interactionCurve,
      height: 60,
      decoration: BoxDecoration(
        color: _pressed ? tokens.colors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(tokens.radii.large),
      ),
      alignment: Alignment.center,
      child: widget.child,
    );
    if (widget.onPressed == null) {
      return key;
    }
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: key,
      ),
    );
  }
}
