# TsaiLineChart

Smooth 294×256 trend chart with a 44-pixel tooltip zone, plot, and Mini Tabs.
Default state paints `accent.default` stroke, the indigo area gradient, and an
endpoint dot with `accent.halo`. Press and hold to scrub.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/charts/line-chart){ target="_blank" rel="noopener" .md-button }

```dart
TsaiLineChart(
  points: points,
  period: TsaiChartPeriod.oneMonth,
  status: TsaiChartStatus.data,
  onPeriodChanged: (period) => setPeriod(period),
  onRetry: reload,
)
```

Statuses are `data`, `loading`, `empty`, and `error`. Hideable layers:
`showGrid`, `showBaseline`, `showAxisY`, `showAxisX`, `showArea`, `showDot`,
and `showTabs`.
