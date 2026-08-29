# TsaiMiniTabs

Segmented period selector. The track is 294×28 with `surface.1`, a hairline
border, and `radius.inner.md`. Each Mini Tab is 24 tall with `radius.sm` and
`type.badge.label`. The active segment uses `surface.indigo.default`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/charts/mini-tabs){ target="_blank" rel="noopener" .md-button }

```dart
TsaiMiniTabs(
  labels: const ['1D', '1W', '1M', '1Y', 'All'],
  selectedIndex: 2,
  onChanged: (index) => setPeriod(index),
)
```

Omit unused trailing labels. Remaining segments share the width equally.
