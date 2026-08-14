# TsaiToast

A compact 48-pixel glass notification in the Undo, Action, and Info
compositions defined in Penpot.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/feedback/toast){ target="_blank" rel="noopener" .md-button }

```dart
TsaiToast(
  variant: TsaiToastVariant.undo,
  message: 'Item deleted',
  actionLabel: 'Undo',
  secondsRemaining: 7,
  countdownProgress: 0.7,
  onAction: restoreItem,
)
```

The component applies the semantic dim-glass surface and backdrop blur. Use
`info` for a message with dismissal only and `action` for an action plus close
control.
