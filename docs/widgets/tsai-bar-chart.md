# TsaiBarChart

294×256 vertical bar chart. Periods `1D`, `1W`, `1M`, `1Y`, and `All` set bar
count, width, and gap so the row fills 294 pixels. Dense periods use
`radius.xs` on the top corners; others use `radius.sm`.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/charts/bar-chart){ target="_blank" rel="noopener" .md-button }

```dart
TsaiBarChart(
  points: points,
  period: TsaiChartPeriod.oneWeek,
  status: TsaiChartStatus.data,
  onPeriodChanged: (period) => setPeriod(period),
  onScrubIndexChanged: (index) => setScrub(index),
  onRetry: reload,
)
```

`status` is the same data-source contract as [TsaiLineChart](tsai-line-chart.md).
Hold a bar to scrub; other bars dim to `accent.muted`. After release the
selection stays. The 96×44 tooltip pins flush on the first or last bar.
`showTabs` hides Mini Tabs when the host supplies another period control.
