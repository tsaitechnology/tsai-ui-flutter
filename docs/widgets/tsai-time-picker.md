# TsaiTimePicker

Wheel-style 24-hour time picker. Atoms are `TsaiTimeWheelColumn`,
`TsaiTimeColon`, and `TsaiTimeWheel`. The wheel is 342×220 with five 44-pixel
rows, an indigo highlight on the selected row, and ramped type (22 / 17 / 15).
Hour and minute wheels are 60 wide with a 12-pixel colon and 12-pixel gaps on
each side. Use `showTsaiTimePicker` for the `Select time` sheet with Cancel /
Apply. `minuteStep` may be 1, 5, or 15.

[Open live example](https://tsaitechnology.github.io/tsai-ui-flutter/example/#/time-picker){ target="_blank" rel="noopener" .md-button }

```dart
final time = await showTsaiTimePicker(
  context: context,
  minuteStep: 5,
);

const TsaiTimePicker(
  initialTime: TimeOfDay(hour: 15, minute: 30),
)
```
