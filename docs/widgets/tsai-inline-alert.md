# TsaiInlineAlert

An inline status message with Info, Success, Error, and Warning treatments.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/feedback/inline-alert){ target="_blank" rel="noopener" .md-button }

```dart
TsaiInlineAlert(
  tone: TsaiInlineAlertTone.warning,
  title: 'Review required',
  message: 'Confirm the recipient before continuing.',
  onDismiss: dismissAlert,
)
```

Each tone uses its corresponding semantic accent, surface, and border tokens.
Pass a custom `icon` only when the status meaning remains unambiguous.
