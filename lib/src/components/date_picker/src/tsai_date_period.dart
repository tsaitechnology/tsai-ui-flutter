part of '../tsai_date_picker.dart';

/// Granularity of a [TsaiDatePeriod] selection.
enum TsaiDateGranularity {
  /// Day range on a weekly calendar.
  weekly,

  /// Month range on a 12-month grid.
  monthly,

  /// Year range on a 12-year grid.
  yearly,
}

/// A single value or inclusive range at one [TsaiDateGranularity].
@immutable
class TsaiDatePeriod {
  /// Creates a period. [end] is omitted for a single value.
  const TsaiDatePeriod({
    required this.start,
    required this.granularity,
    this.end,
  });

  /// Inclusive start (date, month, or year depending on [granularity]).
  final DateTime start;

  /// Inclusive end. Null means a single [start] value.
  final DateTime? end;

  /// Calendar resolution.
  final TsaiDateGranularity granularity;

  /// Normalized inclusive end (same as [start] when [end] is null).
  DateTime get resolvedEnd => end ?? start;

  /// Whether this period spans more than one unit.
  bool get isRange => end != null && !_sameUnit(start, end!, granularity);

  @override
  bool operator ==(Object other) =>
      other is TsaiDatePeriod &&
      other.granularity == granularity &&
      other.start == start &&
      other.end == end;

  @override
  int get hashCode => Object.hash(granularity, start, end);
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime _monthOnly(DateTime value) => DateTime(value.year, value.month);

DateTime _yearOnly(DateTime value) => DateTime(value.year);

int _unitIndex(DateTime value, TsaiDateGranularity granularity) {
  final date = _dateOnly(value);
  return switch (granularity) {
    TsaiDateGranularity.weekly => date.year * 400 + date.month * 32 + date.day,
    TsaiDateGranularity.monthly => date.year * 12 + date.month,
    TsaiDateGranularity.yearly => date.year,
  };
}

bool _sameUnit(DateTime a, DateTime b, TsaiDateGranularity granularity) =>
    _unitIndex(a, granularity) == _unitIndex(b, granularity);

bool _isAfterToday(
  DateTime value,
  DateTime today,
  TsaiDateGranularity granularity,
) => _unitIndex(value, granularity) > _unitIndex(today, granularity);

DateTime _minUnit(DateTime a, DateTime b, TsaiDateGranularity granularity) =>
    _unitIndex(a, granularity) <= _unitIndex(b, granularity) ? a : b;

DateTime _maxUnit(DateTime a, DateTime b, TsaiDateGranularity granularity) =>
    _unitIndex(a, granularity) >= _unitIndex(b, granularity) ? a : b;

bool _inRange(
  DateTime value,
  DateTime start,
  DateTime end,
  TsaiDateGranularity granularity,
) {
  final index = _unitIndex(value, granularity);
  final low = _unitIndex(start, granularity);
  final high = _unitIndex(end, granularity);
  return index >= low && index <= high;
}

const _monthNames = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const _monthShortNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String _monthTitle(DateTime month) =>
    '${_monthNames[month.month - 1]} ${month.year}';
