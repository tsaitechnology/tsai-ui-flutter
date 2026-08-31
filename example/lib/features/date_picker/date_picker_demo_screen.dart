import 'package:flutter/material.dart';
import 'package:tsai_ui/tsai_ui.dart';

import '../../demo/component_demo_window.dart';
import '../../demo/component_playground.dart';

class DatePickerDemoScreen extends StatelessWidget {
  const DatePickerDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.datePicker,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const DatePickerDemo(),
  );
}

class TimePickerDemoScreen extends StatelessWidget {
  const TimePickerDemoScreen({
    required this.themeMode,
    required this.onThemeModeChanged,
    super.key,
  });

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  Widget build(BuildContext context) => ComponentDemoWindow(
    section: ComponentDemoSection.timePicker,
    themeMode: themeMode,
    onThemeModeChanged: onThemeModeChanged,
    child: const TimePickerDemo(),
  );
}

class DatePickerDemo extends StatefulWidget {
  const DatePickerDemo({super.key});

  @override
  State<DatePickerDemo> createState() => _DatePickerDemoState();
}

class _DatePickerDemoState extends State<DatePickerDemo> {
  static final _now = DateTime(2026, 8, 30);
  var _locale = const Locale('en');
  DateTime? _date = DateTime(2026, 8, 12);
  DateTimeRange? _range = DateTimeRange(
    start: DateTime(2026, 8, 5),
    end: DateTime(2026, 8, 13),
  );
  DateTime? _month = DateTime(2026, 8);
  int? _year = 2026;
  var _blockFuture = true;
  var _blockPast = false;

  DateTime? get _firstDate => _blockPast ? _now : DateTime(2018, 1, 1);
  DateTime? get _lastDate => _blockFuture ? _now : DateTime(2032, 12, 31);

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: _locale,
      child: ListView(
        key: const ValueKey<String>('date-picker-demo'),
        padding: const EdgeInsets.all(24),
        children: [
          ComponentPlayground(
            controls: [
              PlaygroundSelectControl<Locale>(
                label: 'locale',
                value: _locale,
                values: const [Locale('en'), Locale('ru'), Locale('de')],
                labels: const ['en', 'ru', 'de'],
                onChanged: (value) => setState(() => _locale = value),
              ),
              PlaygroundToggleControl(
                label: 'blockFuture (lastDate = today)',
                value: _blockFuture,
                onChanged: (value) => setState(() => _blockFuture = value),
              ),
              PlaygroundToggleControl(
                label: 'blockPast (firstDate = today)',
                value: _blockPast,
                onChanged: (value) => setState(() => _blockPast = value),
              ),
            ],
            preview: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TsaiDateField(
                  placeholder: 'Date',
                  value: _date,
                  now: _now,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  onChanged: (value) => setState(() => _date = value),
                ),
                const SizedBox(height: 16),
                TsaiDateRangeField(
                  placeholder: 'Period',
                  value: _range,
                  now: _now,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  onChanged: (value) => setState(() => _range = value),
                ),
                const SizedBox(height: 16),
                TsaiMonthField(
                  placeholder: 'Month',
                  value: _month,
                  now: _now,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  onChanged: (value) => setState(() => _month = value),
                ),
                const SizedBox(height: 16),
                TsaiYearField(
                  placeholder: 'Year',
                  value: _year,
                  now: _now,
                  firstDate: _firstDate,
                  lastDate: _lastDate,
                  onChanged: (value) => setState(() => _year = value),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimePickerDemo extends StatefulWidget {
  const TimePickerDemo({super.key});

  @override
  State<TimePickerDemo> createState() => _TimePickerDemoState();
}

class _TimePickerDemoState extends State<TimePickerDemo> {
  var _step = 1;
  TimeOfDay? _time = const TimeOfDay(hour: 15, minute: 30);

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey<String>('time-picker-demo'),
      padding: const EdgeInsets.all(24),
      children: [
        ComponentPlayground(
          controls: [
            PlaygroundSelectControl<int>(
              label: 'minuteStep',
              value: _step,
              values: const [1, 5, 15],
              labels: const ['1', '5', '15'],
              onChanged: (value) => setState(() => _step = value),
            ),
          ],
          preview: TsaiTimeField(
            placeholder: 'Time',
            minuteStep: _step,
            value: _time,
            onChanged: (value) => setState(() => _time = value),
          ),
        ),
      ],
    );
  }
}
