part of '../tsai_date_picker.dart';

/// Day, month, or year grid with header drill-down.
class TsaiCalendarPicker extends StatefulWidget {
  /// Creates a 342-wide calendar picker.
  const TsaiCalendarPicker({
    super.key,
    this.kind = TsaiCalendarKind.date,
    this.initialDate,
    this.initialRange,
    this.initialMonth,
    this.initialYear,
    this.firstDate,
    this.lastDate,
    this.now,
    this.onDateChanged,
    this.onRangeChanged,
    this.onMonthChanged,
    this.onYearChanged,
  });

  /// What Apply should be able to commit.
  final TsaiCalendarKind kind;

  /// Seed for a single-day picker.
  final DateTime? initialDate;

  /// Seed for a range picker.
  final DateTimeRange? initialRange;

  /// Seed for a month picker (`year` + `month`).
  final DateTime? initialMonth;

  /// Seed for a year picker.
  final int? initialYear;

  /// Inclusive lower bound. Null means open past.
  final DateTime? firstDate;

  /// Inclusive upper bound. Null means open future.
  final DateTime? lastDate;

  /// Clock used to mark today. Defaults to `DateTime.now()`.
  final DateTime? now;

  /// Called when the in-memory day changes.
  final ValueChanged<DateTime?>? onDateChanged;

  /// Called when the in-memory range is complete or cleared.
  final ValueChanged<DateTimeRange?>? onRangeChanged;

  /// Called when the in-memory month changes.
  final ValueChanged<DateTime?>? onMonthChanged;

  /// Called when the in-memory year changes.
  final ValueChanged<int?>? onYearChanged;

  @override
  State<TsaiCalendarPicker> createState() => _TsaiCalendarPickerState();
}

class _TsaiCalendarPickerState extends State<TsaiCalendarPicker> {
  late TsaiCalendarView _view;
  late DateTime _visibleMonth;
  late int _yearPageEnd;
  late List<DateTime> _dates;
  DateTime? _month;
  int? _year;

  DateTime get _today => _dateOnly(widget.now ?? DateTime.now());

  @override
  void initState() {
    super.initState();
    _view = switch (widget.kind) {
      TsaiCalendarKind.year => TsaiCalendarView.year,
      TsaiCalendarKind.month => TsaiCalendarView.month,
      TsaiCalendarKind.date ||
      TsaiCalendarKind.dateRange => TsaiCalendarView.day,
    };
    final seed =
        widget.initialDate ??
        widget.initialRange?.start ??
        widget.initialMonth ??
        (widget.initialYear != null ? DateTime(widget.initialYear!) : _today);
    _visibleMonth = _monthOnly(seed);
    _yearPageEnd = seed.year;
    _dates = switch (widget.kind) {
      TsaiCalendarKind.date when widget.initialDate != null => [
        _dateOnly(widget.initialDate!),
      ],
      TsaiCalendarKind.dateRange when widget.initialRange != null => [
        _dateOnly(widget.initialRange!.start),
        _dateOnly(widget.initialRange!.end),
      ],
      _ => const [],
    };
    _month = widget.initialMonth == null
        ? null
        : _monthOnly(widget.initialMonth!);
    _year = widget.initialYear;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _emit();
      }
    });
  }

  void _emit() {
    switch (widget.kind) {
      case TsaiCalendarKind.date:
        widget.onDateChanged?.call(_dates.isEmpty ? null : _dates.first);
      case TsaiCalendarKind.dateRange:
        if (_dates.length < 2) {
          widget.onRangeChanged?.call(null);
        } else {
          widget.onRangeChanged?.call(
            DateTimeRange(
              start: _minDay(_dates[0], _dates[1]),
              end: _maxDay(_dates[0], _dates[1]),
            ),
          );
        }
      case TsaiCalendarKind.month:
        widget.onMonthChanged?.call(_month);
      case TsaiCalendarKind.year:
        widget.onYearChanged?.call(_year);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      key: const ValueKey<String>('tsai-calendar-picker'),
      width: TsaiDatePickerMetrics.width,
      child: switch (_view) {
        TsaiCalendarView.day => TsaiCalendarMonth(
          visibleMonth: _visibleMonth,
          today: _today,
          selectedDates: _dates,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onDayPressed: _selectDay,
          onMonthPressed: () => _setView(TsaiCalendarView.month),
          onYearPressed: () => _setView(TsaiCalendarView.year),
          onPrevious: _canShiftMonth(-1) ? () => _shiftMonth(-1) : null,
          onNext: _canShiftMonth(1) ? () => _shiftMonth(1) : null,
          previousEnabled: _canShiftMonth(-1),
          nextEnabled: _canShiftMonth(1),
        ),
        TsaiCalendarView.month => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiCalendarHeader(
              yearLabel: _yearFormat(context, null).format(_visibleMonth),
              onYearPressed: () => _setView(TsaiCalendarView.year),
              onPrevious: _canShiftYear(-1) ? () => _shiftYear(-1) : null,
              onNext: _canShiftYear(1) ? () => _shiftYear(1) : null,
              previousEnabled: _canShiftYear(-1),
              nextEnabled: _canShiftYear(1),
            ),
            SizedBox(height: tokens.spacing.space8),
            TsaiPeriodGrid(tiles: _monthTiles(context)),
          ],
        ),
        TsaiCalendarView.year => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TsaiCalendarHeader(
              title: '${_yearPageEnd - 11} – $_yearPageEnd',
              onPrevious: _canShiftYearPage(-1)
                  ? () => _shiftYearPage(-1)
                  : null,
              onNext: _canShiftYearPage(1) ? () => _shiftYearPage(1) : null,
              previousEnabled: _canShiftYearPage(-1),
              nextEnabled: _canShiftYearPage(1),
            ),
            SizedBox(height: tokens.spacing.space8),
            TsaiPeriodGrid(tiles: _yearTiles()),
          ],
        ),
      },
    );
  }

  void _setView(TsaiCalendarView view) => setState(() => _view = view);

  bool _canShiftMonth(int delta) {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    return _monthSelectable(next, widget.firstDate, widget.lastDate);
  }

  bool _canShiftYear(int delta) {
    final year = _visibleMonth.year + delta;
    return _yearSelectable(year, widget.firstDate, widget.lastDate);
  }

  bool _canShiftYearPage(int delta) {
    final end = _yearPageEnd + delta * 12;
    final start = end - 11;
    for (var year = start; year <= end; year++) {
      if (_yearSelectable(year, widget.firstDate, widget.lastDate)) {
        return true;
      }
    }
    return false;
  }

  void _shiftMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  void _shiftYear(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year + delta, _visibleMonth.month);
    });
  }

  void _shiftYearPage(int delta) {
    setState(() {
      _yearPageEnd += delta * 12;
    });
  }

  void _selectDay(DateTime value) {
    final day = _dateOnly(value);
    setState(() {
      if (widget.kind == TsaiCalendarKind.date) {
        _dates = [day];
      } else if (_dates.length >= 2) {
        _dates = [day];
      } else {
        _dates = [..._dates, day];
      }
    });
    _emit();
  }

  void _selectMonth(DateTime month) {
    setState(() {
      _visibleMonth = month;
      if (widget.kind == TsaiCalendarKind.month) {
        _month = month;
      } else {
        _view = TsaiCalendarView.day;
      }
    });
    if (widget.kind == TsaiCalendarKind.month) {
      _emit();
    }
  }

  void _selectYear(int year) {
    setState(() {
      _visibleMonth = DateTime(year, _visibleMonth.month);
      if (year > _yearPageEnd || year < _yearPageEnd - 11) {
        _yearPageEnd = year;
      }
      if (widget.kind == TsaiCalendarKind.year) {
        _year = year;
      } else {
        _view = TsaiCalendarView.month;
      }
    });
    if (widget.kind == TsaiCalendarKind.year) {
      _emit();
    }
  }

  List<TsaiPickerTile> _monthTiles(BuildContext context) {
    final names = DateFormat.MMM(_localeName(context));
    return [
      for (var month = 1; month <= 12; month++)
        TsaiPickerTile(
          label: names.format(DateTime(_visibleMonth.year, month)),
          state: _monthTileState(DateTime(_visibleMonth.year, month)),
          onPressed:
              _monthSelectable(
                DateTime(_visibleMonth.year, month),
                widget.firstDate,
                widget.lastDate,
              )
              ? () => _selectMonth(DateTime(_visibleMonth.year, month))
              : null,
        ),
    ];
  }

  List<TsaiPickerTile> _yearTiles() {
    final startYear = _yearPageEnd - 11;
    return [
      for (var year = startYear; year <= _yearPageEnd; year++)
        TsaiPickerTile(
          label: '$year',
          state: _yearTileState(year),
          onPressed: _yearSelectable(year, widget.firstDate, widget.lastDate)
              ? () => _selectYear(year)
              : null,
        ),
    ];
  }

  TsaiPickerTileState _monthTileState(DateTime month) {
    if (!_monthSelectable(month, widget.firstDate, widget.lastDate)) {
      return TsaiPickerTileState.disabled;
    }
    if (_month != null &&
        month.year == _month!.year &&
        month.month == _month!.month) {
      return TsaiPickerTileState.selected;
    }
    if (month.year == _today.year && month.month == _today.month) {
      return TsaiPickerTileState.current;
    }
    return TsaiPickerTileState.standard;
  }

  TsaiPickerTileState _yearTileState(int year) {
    if (!_yearSelectable(year, widget.firstDate, widget.lastDate)) {
      return TsaiPickerTileState.disabled;
    }
    if (_year == year) {
      return TsaiPickerTileState.selected;
    }
    if (year == _today.year) {
      return TsaiPickerTileState.current;
    }
    return TsaiPickerTileState.standard;
  }
}
