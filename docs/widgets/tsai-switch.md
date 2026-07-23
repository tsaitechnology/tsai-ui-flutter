# TsaiSwitch

A controlled binary switch with an optional label, description, focus callback,
and configurable label position.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/switch){ target="_blank" rel="noopener" .md-button }

```dart
TsaiSwitch(
  value: notificationsEnabled,
  label: 'Notifications',
  description: 'Receive operational alerts',
  onChanged: (value) => setState(() => notificationsEnabled = value),
)
```

Set `onChanged` to `null` for a disabled switch. Provide `semanticLabel` when
the visible label does not describe the setting independently.
