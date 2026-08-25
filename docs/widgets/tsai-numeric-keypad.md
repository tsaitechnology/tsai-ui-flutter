# TsaiNumericKeypad

A 358×240 four-row digit pad. Keys are 114×60 with `radius.lg`. The default
key is transparent; the pressed key uses `color.surface.1`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/keypad){ target="_blank" rel="noopener" .md-button }

```dart
TsaiNumericKeypad(
  mode: TsaiKeypadMode.decimal,
  onDigit: appendDigit,
  onDecimal: appendDecimal,
  onBackspace: deleteLast,
)
```

`TsaiKeypadMode.integer` hides the decimal key. `TsaiKeypadMode.pin` replaces
it with a biometric action.
