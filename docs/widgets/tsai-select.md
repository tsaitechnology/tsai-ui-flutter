# TsaiSelect

A controlled generic select. Options always open in a half-height
`TsaiBottomSheet` titled with the field label, with an X close control and no
search or action buttons. Selected options use the List Item Active surface.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/select){ target="_blank" rel="noopener" .md-button }

```dart
TsaiSelect<String>(
  placeholder: 'Region',
  value: region,
  options: const [
    TsaiSelectOption(
      value: 'uy',
      label: 'Uruguay',
      icon: TsaiIcon.emoji('🇺🇾', size: 20),
    ),
    TsaiSelectOption(
      value: 'br',
      label: 'Brazil',
      icon: TsaiIcon.emoji('🇧🇷', size: 20),
    ),
  ],
  onChanged: (value) => setState(() => region = value),
)
```

Set `onChanged` to `null` to disable the select. Use `errorText` instead of
`description` for validation feedback. `presentation` is retained for
compatibility; options always open in a bottom sheet. Each option accepts an
optional `TsaiIcon`, so the same slot supports Lucide, emoji, SVG, and PNG
sources without exposing icon rendering properties through the select API.
