# CircleIcon

`CircleIcon` provides the Penpot `icon-circle` geometry: a fixed 40-by-40
token-backed circular surface with a centered 20-pixel icon.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/icons/circle-icon){ target="_blank" rel="noopener" .md-button }

```dart
const CircleIcon(
  icon: TsaiIcon(LucideIcons.coffee, size: 20),
  semanticLabel: 'Coffee',
)
```

The surface uses `surfaceRaised`. The glyph is tinted with `iconSecondary`,
including when the supplied widget has its own color.
