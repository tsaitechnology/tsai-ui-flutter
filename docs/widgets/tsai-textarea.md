# TsaiTextarea

The field plate is 120 pixels tall by default (`radius.md`, `surface.1`,
12/16 padding). Empty default is a 16-pixel tertiary label; focus raises it to
13 pixels and shows the caret on the value row. The meta row keeps helper copy
in `text.secondary`; only the optional counter turns `semantic.accent.error` in
the Error state.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/input-textarea){ target="_blank" rel="noopener" .md-button }

```dart
TsaiTextarea(
  placeholder: 'Label',
  description: 'Description',
  maxLength: 500,
  showCharacterCounter: true,
  onChanged: (value) => setState(() => note = value),
)
```

Empty default shows a single 16-pixel floating label. Focus, filling, filled,
error, and disabled match Input. The counter is hidden unless
`showCharacterCounter` is true. Stretch `fieldHeight` when a usage needs a
taller plate; content stays top-aligned.
