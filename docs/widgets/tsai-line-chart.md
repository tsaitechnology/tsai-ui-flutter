# TsaiLineChart

Smooth 294×256 trend chart with a 44-pixel tooltip zone, plot, and Mini Tabs.
Default state paints `accent.default` stroke, the indigo area gradient, and an
endpoint dot with `accent.halo`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/charts/line-chart){ target="_blank" rel="noopener" .md-button }

```dart
TsaiLineChart(
  points: points,
  period: TsaiChartPeriod.oneMonth,
  status: TsaiChartStatus.data,
  onPeriodChanged: (period) => setPeriod(period),
  onScrubIndexChanged: (index) => setScrub(index),
  onRetry: reload,
)
```

Pass `status` from the data source:

- `loading` — request in flight. Mini Tabs ignore taps. If a series was
  already shown, that plot is painted as the skeleton. After a first load,
  error retry, or empty plot, the Penpot Loading silhouette is used instead.
  Keep `period` on the requested window; the gray plot may still show the
  previous window until `data` arrives.
- `empty` — loaded, no samples for this period
- `data` — loaded series; Mini Tabs call `onPeriodChanged`
- `error` — request failed; `onRetry` is the plot link. Set `loading` again
  while the retry request runs so the canonical skeleton shows.

Hold on the plot to scrub, then move; the tooltip stays after release until
`status` or `period` changes. Mouse hover previews without committing. The
96×44 tooltip pins flush to a side near an edge.

Hideable layers: `showGrid`, `showBaseline`, `showAxisY`, `showAxisX`,
`showArea`, `showDot`, and `showTabs`.
