# TsaiOtpInput

A numeric one-time-password input rendered as individual cells.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/input-otp){ target="_blank" rel="noopener" .md-button }

```dart
TsaiOtpInput(
  length: 6,
  onChanged: (value) => code = value,
  onCompleted: verifyCode,
  semanticLabel: 'Six-digit verification code',
)
```

`length` must be greater than zero. `isError` and `isSuccess` are mutually
exclusive. Do not provide both `controller` and `initialValue`.
