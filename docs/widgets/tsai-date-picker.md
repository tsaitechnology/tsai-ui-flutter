# TsaiCalendarPicker

Day calendar with month and year drill-down. There are no Weekly / Monthly /
Yearly tabs. The header on the day grid is two actions (`August` and `2026`);
chevrons move by month. Tapping the month opens a 12-month grid (year action +
year chevrons). Tapping the year opens a 12-year grid (title is not tappable).
Choosing a year always returns to the month grid, then the day grid.

Use `showTsaiDatePicker` / `showTsaiDateRangePicker` / `showTsaiMonthPicker` /
`showTsaiYearPicker` for content-sized sheets (Cancel always, Apply when the
draft can be committed). Bounds are `firstDate` and `lastDate` (either may be
null). Range selection stores up to two days: the earlier is start, the later
is end; a third tap resets the array.

Form fields: `TsaiDateField`, `TsaiDateRangeField`, `TsaiMonthField`,
`TsaiYearField`. They follow `TsaiInput` (labeled placeholder, description,
error). Display uses `intl` `DateFormat` in the ambient locale.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/date-picker){ target="_blank" rel="noopener" .md-button }

```dart
TsaiDateField(
  value: date,
  firstDate: DateTime(2020),
  lastDate: DateTime.now(),
  onChanged: (value) => setState(() => date = value),
);

final range = await showTsaiDateRangePicker(context: context);
```
