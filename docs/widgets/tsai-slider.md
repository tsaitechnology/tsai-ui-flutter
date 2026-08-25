# TsaiSlider

A stretchable single-thumb slider. The track is 4px with a pill radius. The
fill uses `color.accent.default` and the thumb uses `color.text.onAccent.primary`
with a soft shadow. Disabled fill uses `color.border.strong` and the thumb uses
`color.icon.tertiary`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/slider){ target="_blank" rel="noopener" .md-button }

```dart
TsaiSlider(
  value: amount,
  min: 0,
  max: 100,
  onChanged: (value) => setState(() => amount = value),
)
```

Set `onChanged` to `null` to disable the slider. The thumb center tracks the
fill edge.
