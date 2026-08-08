# TsaiGlow

A decorative, theme-aware blurred accent used behind large surfaces such as
bottom sheets.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/effects/glow){ target="_blank" rel="noopener" .md-button }

```dart
const Positioned(
  top: -280,
  child: TsaiGlow(),
)
```

The Penpot default is a 480-pixel circle with a blur radius of 170. The widget
is excluded from semantics and ignores pointer input. Place it in a clipped
`Stack` when the glow must remain inside a surface.
