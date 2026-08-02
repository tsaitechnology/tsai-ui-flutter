# TsaiTextCaption

Inter caption text in `medium` or `small` size and `regular` or `medium` weight.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/typography/caption){ target="_blank" rel="noopener" .md-button }

```dart
const TsaiTextCaption(
  'Updated a moment ago',
  size: TsaiCaptionSize.medium,
  weight: TsaiTextWeight.regular,
)
```

Captions are suitable for supporting metadata. Keep essential instructions in
body text so they remain prominent at larger accessibility text scales.
Text casing is preserved for both sizes. Apply uppercase or any other casing at
the call site when the surrounding composition requires it.
