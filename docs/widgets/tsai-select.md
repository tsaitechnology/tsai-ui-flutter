# TsaiSelect

A controlled generic select. It uses an anchored menu on web and desktop, and
the shared `TsaiBottomSheet` component on Android and iOS. Mobile selects use
the bottom sheet even when a menu presentation override is supplied.

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
`description` for validation feedback. `presentation` can choose an anchored
menu or bottom sheet for non-mobile hosts; mobile hosts always use the bottom
sheet. Each option accepts an
optional `TsaiIcon`, so the same slot supports Lucide, emoji, SVG, and PNG
sources without exposing icon rendering properties through the select API.
