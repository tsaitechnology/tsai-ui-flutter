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
  onRetry: reload,
)
```

Press and hold a bar to scrub. Other bars dim to `accent.muted`. Loading, empty,
and error states match Line Chart. Mini Tabs stay interactive while loading.
