# TsaiLink

A compact inline action with optional leading and trailing icons and default,
active, disabled, focus, pointer, and keyboard states.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/links){ target="_blank" rel="noopener" .md-button }

```dart
TsaiLink(
  label: 'View details',
  trailingIcon: const TsaiIcon(LucideIcons.chevron_right, size: 16),
  onPressed: openDetails,
)
```

Set `onPressed` to `null` for the disabled state. Use `semanticLabel` when the
visible label does not describe the destination or action independently.
