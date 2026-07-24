# TsaiSelect

A controlled generic select. Adaptive presentation uses an anchored menu on
web/desktop, a bottom sheet on Android, and a Cupertino picker on iOS.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/select){ target="_blank" rel="noopener" .md-button }

```dart
TsaiSelect<String>(
  label: 'Region',
  placeholder: 'Choose a region',
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
`description` for validation feedback. `presentation` can force a platform
presentation when adaptive behavior is not appropriate. Each option accepts an
optional `TsaiIcon`, so the same slot supports Lucide, emoji, SVG, and PNG
sources without exposing icon rendering properties through the select API.
