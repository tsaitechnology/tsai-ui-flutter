part of '../tsai_date_picker.dart';

/// Assembled day calendar: header, weekdays, and a 6-week grid.
class TsaiCalendarMonth extends StatelessWidget {
  /// Creates a 342-wide calendar for [visibleMonth].
  const TsaiCalendarMonth({
    required this.visibleMonth,
    required this.today,
    super.key,
    this.selectedDates = const [],
    this.firstDate,
    this.lastDate,
    this.onDayPressed,
    this.onPrevious,
    this.onNext,
    this.onMonthPressed,
    this.onYearPressed,
    this.nextEnabled = true,
    this.previousEnabled = true,
  });

  /// First day of the displayed month.
  final DateTime visibleMonth;

  /// Clock used to mark today.
  final DateTime today;

  /// Zero, one, or two selected days.
  final List<DateTime> selectedDates;

  /// Inclusive lower bound. Null means open.
  final DateTime? firstDate;

  /// Inclusive upper bound. Null means open.
  final DateTime? lastDate;

  /// Called with a date-only value when an enabled day is pressed.
  final ValueChanged<DateTime>? onDayPressed;

  /// Previous-month chevron.
  final VoidCallback? onPrevious;

  /// Next-month chevron.
  final VoidCallback? onNext;

  /// Opens the month grid.
  final VoidCallback? onMonthPressed;

  /// Opens the year grid.
  final VoidCallback? onYearPressed;

  /// Whether the next chevron is enabled.
  final bool nextEnabled;

  /// Whether the previous chevron is enabled.
  final bool previousEnabled;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final month = _monthOnly(visibleMonth);
    final days = _monthCells(month);
    return SizedBox(
      key: const ValueKey<String>('tsai-calendar-month'),
      width: TsaiDatePickerMetrics.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TsaiCalendarHeader(
            monthLabel: _monthNameFormat(context).format(month),
            yearLabel: _yearFormat(context, null).format(month),
            onMonthPressed: onMonthPressed,
            onYearPressed: onYearPressed,
            onPrevious: onPrevious,
            onNext: onNext,
            previousEnabled: previousEnabled,
            nextEnabled: nextEnabled,
          ),
          SizedBox(height: tokens.spacing.space8),
          const TsaiCalendarWeekdays(),
          SizedBox(height: tokens.spacing.space8),
          for (var row = 0; row < 6; row++) ...[
            if (row > 0)
              const SizedBox(height: TsaiDatePickerMetrics.dayRowGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var column = 0; column < 7; column++)
                  TsaiCalendarDayCell(
                    label: days[row * 7 + column].label,
                    state: days[row * 7 + column].state,
                    onPressed:
                        days[row * 7 + column].date == null ||
                            days[row * 7 + column].state ==
                                TsaiCalendarDayCellState.disabled
                        ? null
                        : () =>
                              onDayPressed?.call(days[row * 7 + column].date!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  List<_DayModel> _monthCells(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = (first.weekday + 6) % 7;
    final todayDate = _dateOnly(today);
    final selected = selectedDates.map(_dateOnly).toList();
    final models = <_DayModel>[];
    for (var index = 0; index < 42; index++) {
      final dayNumber = index - leading + 1;
      if (dayNumber < 1 || dayNumber > daysInMonth) {
        models.add(const _DayModel.empty());
        continue;
      }
      final date = DateTime(month.year, month.month, dayNumber);
      models.add(
        _DayModel(
          date: date,
          label: '$dayNumber',
          state: _dayState(date, todayDate, selected),
        ),
      );
    }
    return models;
  }

  TsaiCalendarDayCellState _dayState(
    DateTime date,
    DateTime todayDate,
    List<DateTime> selected,
  ) {
    if (!_daySelectable(date, firstDate, lastDate)) {
      return TsaiCalendarDayCellState.disabled;
    }
    if (selected.length >= 2) {
      final start = _minDay(selected[0], selected[1]);
      final end = _maxDay(selected[0], selected[1]);
      final isStart = _sameDay(date, start);
      final isEnd = _sameDay(date, end);
      if (isStart && isEnd) {
        return TsaiCalendarDayCellState.selected;
      }
      if (isStart) {
        return TsaiCalendarDayCellState.rangeStart;
      }
      if (isEnd) {
        return TsaiCalendarDayCellState.rangeEnd;
      }
      if (_inDayRange(date, start, end)) {
        return TsaiCalendarDayCellState.inRange;
      }
    } else if (selected.length == 1 && _sameDay(date, selected.first)) {
      return TsaiCalendarDayCellState.selected;
    }
    if (_sameDay(date, todayDate)) {
      return TsaiCalendarDayCellState.today;
    }
    return TsaiCalendarDayCellState.standard;
  }
}

@immutable
class _DayModel {
  const _DayModel({required this.label, required this.state, this.date});

  const _DayModel.empty()
    : date = null,
      label = null,
      state = TsaiCalendarDayCellState.empty;

  final DateTime? date;
  final String? label;
  final TsaiCalendarDayCellState state;
}
