# HitIcon

`HitIcon` provides the Penpot `hit-32` geometry: a fixed 32-by-32 interaction
field with a centered 24-pixel icon. It uses the primary icon color token.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/icons/hit-icon){ target="_blank" rel="noopener" .md-button }

```dart
HitIcon(
  icon: const TsaiIcon(LucideIcons.search),
  semanticLabel: 'Search',
  onPressed: openSearch,
)
```

When `onPressed` is null, the geometry and icon remain visible without button
semantics. Interactive targets intentionally have no hover, highlight, or
ripple effect.
