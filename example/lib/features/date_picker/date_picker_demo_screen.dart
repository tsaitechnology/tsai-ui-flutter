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
  var _granularity = TsaiDateGranularity.weekly;
  TsaiDatePeriod? _period = TsaiDatePeriod(
    start: DateTime(2026, 8, 5),
    end: DateTime(2026, 8, 13),
    granularity: TsaiDateGranularity.weekly,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const ValueKey<String>('date-picker-demo'),
      padding: const EdgeInsets.all(24),
      children: [
        ComponentPlayground(
          controls: [
            PlaygroundSelectControl<TsaiDateGranularity>(
              label: 'granularity',
              value: _granularity,
              values: TsaiDateGranularity.values,
              labels: const ['Weekly', 'Monthly', 'Yearly'],
              onChanged: (value) => setState(() => _granularity = value),
            ),
            PlaygroundOutput(
              label: 'Selection',
              value: _period == null
                  ? 'None'
                  : '${_period!.start} → ${_period!.resolvedEnd}',
            ),
          ],
          preview: LayoutBuilder(
            builder: (context, constraints) {
              final picker = Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TsaiDatePeriodPicker(
                    key: ValueKey<TsaiDateGranularity>(_granularity),
                    now: _now,
                    granularity: _granularity,
                    initialPeriod: _period,
                    onChanged: (value) => setState(() => _period = value),
                  ),
                  const SizedBox(height: 16),
                  TsaiButton(
                    label: 'Open sheet',
                    isExpanded: true,
                    onPressed: () async {
                      final result = await showTsaiDatePeriodPicker(
                        context: context,
                        now: _now,
                        granularity: _granularity,
                        initialPeriod: _period,
                      );
                      if (result != null) {
                        setState(() => _period = result);
                      }
                    },
                  ),
                ],
              );
              if (!constraints.hasBoundedHeight) {
                return picker;
              }
              return SingleChildScrollView(child: picker);
            },
          ),
        ),
      ],
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
  var _time = const TimeOfDay(hour: 15, minute: 30);

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
            PlaygroundOutput(
              label: 'Time',
              value: '${_time.hour}:${_time.minute.toString().padLeft(2, '0')}',
            ),
          ],
          preview: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TsaiTimePicker(
                key: ValueKey<int>(_step),
                initialTime: _time,
                minuteStep: _step,
                onChanged: (value) => setState(() => _time = value),
              ),
              const SizedBox(height: 16),
              TsaiButton(
                label: 'Open sheet',
                isExpanded: true,
                onPressed: () async {
                  final result = await showTsaiTimePicker(
                    context: context,
                    initialTime: _time,
                    minuteStep: _step,
                  );
                  if (result != null) {
                    setState(() => _time = result);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
