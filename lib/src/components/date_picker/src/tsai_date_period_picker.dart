part of '../tsai_date_picker.dart';

/// Bottom-sheet body for Weekly / Monthly / Yearly period selection.
class TsaiDatePeriodPicker extends StatefulWidget {
  /// Creates a date/period picker.
  const TsaiDatePeriodPicker({
    super.key,
    this.initialPeriod,
    this.granularity = TsaiDateGranularity.weekly,
    this.now,
    this.onChanged,
  });

  /// Selection shown before the first tap.
  final TsaiDatePeriod? initialPeriod;

  /// Initial Mini Tabs segment.
  final TsaiDateGranularity granularity;

  /// Clock used to disable the future. Defaults to `DateTime.now()`.
  final DateTime? now;

  /// Called after each tap with the in-progress selection.
  final ValueChanged<TsaiDatePeriod>? onChanged;

  @override
  State<TsaiDatePeriodPicker> createState() => _TsaiDatePeriodPickerState();
}

class _TsaiDatePeriodPickerState extends State<TsaiDatePeriodPicker> {
  late TsaiDateGranularity _granularity;
  late DateTime _visibleMonth;
  late int _yearPageEnd;
  DateTime? _anchor;
  DateTime? _extent;

  DateTime get _today => _dateOnly(widget.now ?? DateTime.now());

  @override
  void initState() {
    super.initState();
    _granularity = widget.granularity;
    final seed = widget.initialPeriod?.start ?? _today;
    _visibleMonth = _monthOnly(seed);
    _yearPageEnd = seed.year;
    if (widget.initialPeriod != null) {
      _anchor = widget.initialPeriod!.start;
      _extent = widget.initialPeriod!.end;
    }
  }

  TsaiDatePeriod? get _period {
    if (_anchor == null) {
      return null;
    }
    final start = _extent == null
        ? _anchor!
        : _minUnit(_anchor!, _extent!, _granularity);
    final end = _extent == null
        ? null
        : _maxUnit(_anchor!, _extent!, _granularity);
    return TsaiDatePeriod(
      start: start,
      end: end == null || _sameUnit(start, end, _granularity) ? null : end,
      granularity: _granularity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      key: const ValueKey<String>('tsai-date-period-picker'),
      width: TsaiDatePickerMetrics.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TsaiMiniTabs(
            labels: const ['Weekly', 'Monthly', 'Yearly'],
            selectedIndex: _granularity.index,
            width: TsaiDatePickerMetrics.width,
            onChanged: (index) =>
                _setGranularity(TsaiDateGranularity.values[index]),
          ),
          SizedBox(height: tokens.spacing.space16),
          switch (_granularity) {
            TsaiDateGranularity.weekly => TsaiCalendarMonth(
              visibleMonth: _visibleMonth,
              today: _today,
              selection: _period,
              onDayPressed: _select,
              onPrevious: () => _shiftMonth(-1),
              onNext: _canGoNextMonth ? () => _shiftMonth(1) : null,
              previousEnabled: true,
              nextEnabled: _canGoNextMonth,
            ),
            TsaiDateGranularity.monthly => Column(
              children: [
                TsaiCalendarHeader(
                  title: '${_visibleMonth.year}',
                  onPrevious: () => _shiftYear(-1),
                  onNext: _canGoNextYear ? () => _shiftYear(1) : null,
                  nextEnabled: _canGoNextYear,
                ),
                SizedBox(height: tokens.spacing.space8),
                TsaiPeriodGrid(tiles: _monthTiles()),
              ],
            ),
            TsaiDateGranularity.yearly => Column(
              children: [
                TsaiCalendarHeader(
                  title: '${_yearPageEnd - 11} – $_yearPageEnd',
                  onPrevious: () => _shiftYearPage(-1),
                  onNext: _canGoNextYearPage ? () => _shiftYearPage(1) : null,
                  nextEnabled: _canGoNextYearPage,
                ),
                SizedBox(height: tokens.spacing.space8),
                TsaiPeriodGrid(tiles: _yearTiles()),
              ],
            ),
          },
        ],
      ),
    );
  }

  bool get _canGoNextMonth {
    final next = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    return !_isAfterToday(next, _today, TsaiDateGranularity.monthly);
  }

  bool get _canGoNextYear => _visibleMonth.year < _today.year;

  bool get _canGoNextYearPage => _yearPageEnd < _today.year;

  void _setGranularity(TsaiDateGranularity value) {
    setState(() {
      _granularity = value;
      _anchor = _anchor == null ? null : _normalize(_anchor!, value);
      _extent = _extent == null ? null : _normalize(_extent!, value);
    });
    _emit();
  }

  DateTime _normalize(DateTime value, TsaiDateGranularity granularity) =>
      switch (granularity) {
        TsaiDateGranularity.weekly => _dateOnly(value),
        TsaiDateGranularity.monthly => _monthOnly(value),
        TsaiDateGranularity.yearly => _yearOnly(value),
      };

  void _select(DateTime value) {
    final unit = _normalize(value, _granularity);
    setState(() {
      if (_anchor == null || _extent != null) {
        _anchor = unit;
        _extent = null;
      } else {
        _extent = unit;
      }
    });
    _emit();
  }

  void _shiftMonth(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + delta);
    });
  }

  void _shiftYear(int delta) {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year + delta, 1);
    });
  }

  void _shiftYearPage(int delta) {
    setState(() {
      _yearPageEnd += delta * 12;
    });
  }

  List<TsaiPickerTile> _monthTiles() {
    return [
      for (var month = 1; month <= 12; month++)
        TsaiPickerTile(
          label: _monthShortNames[month - 1],
          state: _tileState(
            DateTime(_visibleMonth.year, month),
            TsaiDateGranularity.monthly,
            current: _monthOnly(_today),
          ),
          onPressed:
              _isAfterToday(
                DateTime(_visibleMonth.year, month),
                _today,
                TsaiDateGranularity.monthly,
              )
              ? null
              : () => _select(DateTime(_visibleMonth.year, month)),
        ),
    ];
  }

  List<TsaiPickerTile> _yearTiles() {
    final startYear = _yearPageEnd - 11;
    return [
      for (var year = startYear; year <= _yearPageEnd; year++)
        TsaiPickerTile(
          label: '$year',
          state: _tileState(
            DateTime(year),
            TsaiDateGranularity.yearly,
            current: _yearOnly(_today),
          ),
          onPressed:
              _isAfterToday(DateTime(year), _today, TsaiDateGranularity.yearly)
              ? null
              : () => _select(DateTime(year)),
        ),
    ];
  }

  TsaiPickerTileState _tileState(
    DateTime value,
    TsaiDateGranularity granularity, {
    required DateTime current,
  }) {
    if (_isAfterToday(value, _today, granularity)) {
      return TsaiPickerTileState.disabled;
    }
    final period = _period;
    if (period != null) {
      final start = period.start;
      final end = period.resolvedEnd;
      final isStart = _sameUnit(value, start, granularity);
      final isEnd = _sameUnit(value, end, granularity);
      if (isStart && isEnd) {
        return TsaiPickerTileState.selected;
      }
      if (isStart) {
        return TsaiPickerTileState.rangeStart;
      }
      if (isEnd) {
        return TsaiPickerTileState.rangeEnd;
      }
      if (_inRange(value, start, end, granularity)) {
        return TsaiPickerTileState.inRange;
      }
    }
    if (_sameUnit(value, current, granularity)) {
      return TsaiPickerTileState.current;
    }
    return TsaiPickerTileState.standard;
  }

  void _emit() {
    final period = _period;
    if (period != null) {
      widget.onChanged?.call(period);
    }
  }
}

/// Opens a bottom sheet titled `Select period` with Cancel / Apply.
Future<TsaiDatePeriod?> showTsaiDatePeriodPicker({
  required BuildContext context,
  TsaiDatePeriod? initialPeriod,
  TsaiDateGranularity granularity = TsaiDateGranularity.weekly,
  DateTime? now,
}) {
  var draft = initialPeriod;
  return showTsaiBottomSheet<TsaiDatePeriod>(
    context: context,
    title: 'Select period',
    showCloseButton: false,
    secondaryAction: Builder(
      builder: (sheetContext) => TsaiButton(
        label: 'Cancel',
        variant: TsaiButtonVariant.ghost,
        isExpanded: true,
        onPressed: () => Navigator.of(sheetContext).pop(),
      ),
    ),
    primaryAction: Builder(
      builder: (sheetContext) => TsaiButton(
        label: 'Apply',
        isExpanded: true,
        onPressed: () => Navigator.of(sheetContext).pop(draft),
      ),
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: TsaiDatePeriodPicker(
          initialPeriod: initialPeriod,
          granularity: granularity,
          now: now,
          onChanged: (value) => draft = value,
        ),
      ),
    ),
  );
}
