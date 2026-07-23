# TsaiCheckbox

A controlled checkbox with optional label, description, error state, label
position, and tristate behavior.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/checkbox){ target="_blank" rel="noopener" .md-button }

```dart
TsaiCheckbox(
  value: accepted,
  label: 'Accept terms',
  description: 'Required to continue',
  onChanged: (value) => setState(() => accepted = value!),
)
```

Set `onChanged` to `null` to disable interaction. With `tristate: true`, values
cycle through `false`, `true`, and `null`. `isError` styles the unchecked state.
