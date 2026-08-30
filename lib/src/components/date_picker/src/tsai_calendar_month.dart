part of '../tsai_date_picker.dart';

/// Assembled weekly calendar: header, weekdays, and a 6-week grid.
class TsaiCalendarMonth extends StatelessWidget {
  /// Creates a 342-wide calendar for [visibleMonth].
  const TsaiCalendarMonth({
    required this.visibleMonth,
    required this.today,
    super.key,
    this.selection,
    this.onDayPressed,
    this.onPrevious,
    this.onNext,
    this.nextEnabled = true,
    this.previousEnabled = true,
  });

  /// First day of the displayed month.
  final DateTime visibleMonth;

  /// Clock used to mark today and disable the future.
  final DateTime today;

  /// Current day selection, if any.
  final TsaiDatePeriod? selection;

  /// Called with a date-only value when an enabled day is pressed.
  final ValueChanged<DateTime>? onDayPressed;

  /// Previous-month chevron.
  final VoidCallback? onPrevious;

  /// Next-month chevron.
  final VoidCallback? onNext;

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
            title: _monthTitle(month),
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
    final start = selection == null ? null : _dateOnly(selection!.start);
    final end = selection == null ? null : _dateOnly(selection!.resolvedEnd);
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
          state: _dayState(date, todayDate, start, end),
        ),
      );
    }
    return models;
  }

  TsaiCalendarDayCellState _dayState(
    DateTime date,
    DateTime todayDate,
    DateTime? start,
    DateTime? end,
  ) {
    if (_isAfterToday(date, todayDate, TsaiDateGranularity.weekly)) {
      return TsaiCalendarDayCellState.disabled;
    }
    if (start != null && end != null) {
      final isStart = _sameUnit(date, start, TsaiDateGranularity.weekly);
      final isEnd = _sameUnit(date, end, TsaiDateGranularity.weekly);
      if (isStart && isEnd) {
        return TsaiCalendarDayCellState.selected;
      }
      if (isStart) {
        return TsaiCalendarDayCellState.rangeStart;
      }
      if (isEnd) {
        return TsaiCalendarDayCellState.rangeEnd;
      }
      if (_inRange(date, start, end, TsaiDateGranularity.weekly)) {
        return TsaiCalendarDayCellState.inRange;
      }
    }
    if (_sameUnit(date, todayDate, TsaiDateGranularity.weekly)) {
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
