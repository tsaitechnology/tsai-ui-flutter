# TsaiActionTile

Home quick actions in Circle, Card, and Ghost variants. Icons use
`color.icon.bright`. Circle rows use `spacing.24`; Card and Ghost rows use
`spacing.4`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/action-tile){ target="_blank" rel="noopener" .md-button }

```dart
TsaiActionTile(
  variant: TsaiActionTileVariant.circle,
  label: 'Send',
  icon: const TsaiIcon(LucideIcons.send),
  onPressed: send,
)
```

Omit `label` to hide the caption. Pressed Circle and Card plates use
`color.surface.2`; pressed Ghost uses `color.surface.1`.
