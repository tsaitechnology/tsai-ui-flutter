# TsaiDatePeriodPicker

Bottom-sheet calendar for Weekly / Monthly / Yearly ranges. Atoms are
`TsaiCalendarDayCell`, `TsaiCalendarHeader`, `TsaiCalendarWeekdays`,
`TsaiCalendarMonth`, `TsaiPickerTile`, and `TsaiPeriodGrid`. The assembled
picker is 342 wide and is shown with `showTsaiDatePeriodPicker` (Cancel / Apply,
no close icon, swipe-down dismisses).

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/date-picker){ target="_blank" rel="noopener" .md-button }

```dart
final period = await showTsaiDatePeriodPicker(
  context: context,
  granularity: TsaiDateGranularity.weekly,
);

TsaiDatePeriodPicker(
  now: DateTime(2026, 8, 30),
  onChanged: (value) => setState(() => period = value),
)
```

Tap once for a single value, tap again for the inclusive span. Values after
today are disabled and the next chevron is blocked at the current period.

Weekly weeks use seven 44-pixel cells packed with `space-between` across 342
width. Monthly and yearly tiles are 108×44 with 8-pixel row gaps.
