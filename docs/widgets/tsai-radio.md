# TsaiRadio

A controlled generic radio control with label, description, error, focus, and
label-position support.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/radio){ target="_blank" rel="noopener" .md-button }

```dart
TsaiRadio<String>(
  value: 'team',
  groupValue: plan,
  label: 'Team',
  description: 'For up to 20 members',
  onChanged: (value) => setState(() => plan = value),
)
```

Controls belong to the same group when they share `groupValue` state. Set
`onChanged` to `null` to disable an option.
