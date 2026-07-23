# TsaiPinInput

A numeric PIN input that represents entered digits as dots.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/input-pin){ target="_blank" rel="noopener" .md-button }

```dart
TsaiPinInput(
  length: 4,
  onChanged: (value) => pin = value,
  onCompleted: unlock,
  semanticLabel: 'Four-digit PIN',
)
```

`length` must be greater than zero. `isError` and `isSuccess` are mutually
exclusive. The editable sequence is exposed to assistive technology through
`semanticLabel`.
