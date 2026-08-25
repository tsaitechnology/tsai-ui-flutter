# TsaiStepper

A pill quantity control with 32×32 minus and plus hit targets and a 32-wide
mono value slot. Glyphs use `color.icon.bright` until a bound is reached, then
`color.icon.tertiary`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/stepper){ target="_blank" rel="noopener" .md-button }

```dart
TsaiStepper(
  value: quantity,
  min: 0,
  max: 99,
  onChanged: (value) => setState(() => quantity = value),
)
```
