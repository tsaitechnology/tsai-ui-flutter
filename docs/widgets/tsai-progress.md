# TsaiProgressBar and TsaiSpinner

Determinate and indeterminate progress indicators matching the Penpot Progress
page.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/feedback/progress){ target="_blank" rel="noopener" .md-button }

```dart
const TsaiProgressBar(
  value: 0.6,
  label: 'Uploading',
  labelPosition: TsaiProgressBarLabelPosition.top,
)

const TsaiSpinner(size: TsaiSpinnerSize.medium)
```

`TsaiProgressBar` accepts values from zero to one and supports normal, success,
and error states. Spinner sizes are 16, 24, and 32 pixels. Both indicators
respect reduced-motion preferences.
