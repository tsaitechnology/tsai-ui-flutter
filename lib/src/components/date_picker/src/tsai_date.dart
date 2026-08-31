part of '../tsai_date_picker.dart';

/// Which surface a [TsaiCalendarPicker] is showing.
enum TsaiCalendarView {
  /// Six-week day grid.
  day,

  /// Twelve-month grid.
  month,

  /// Twelve-year grid.
  year,
}

/// What a [TsaiCalendarPicker] commits on Apply.
enum TsaiCalendarKind {
  /// One calendar day.
  date,

  /// Inclusive day-to-day range.
  dateRange,

  /// A month in a year, without a day.
  month,

  /// A calendar year.
  year,
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

DateTime _monthOnly(DateTime value) => DateTime(value.year, value.month);

int _dayIndex(DateTime value) {
  final date = _dateOnly(value);
  return date.year * 400 + date.month * 32 + date.day;
}

bool _sameDay(DateTime a, DateTime b) => _dayIndex(a) == _dayIndex(b);

bool _isBeforeDay(DateTime value, DateTime bound) =>
    _dayIndex(value) < _dayIndex(bound);

bool _isAfterDay(DateTime value, DateTime bound) =>
    _dayIndex(value) > _dayIndex(bound);

bool _inDayRange(DateTime value, DateTime start, DateTime end) {
  final index = _dayIndex(value);
  final low = _dayIndex(start);
  final high = _dayIndex(end);
  return index >= low && index <= high;
}

DateTime _minDay(DateTime a, DateTime b) =>
    _dayIndex(a) <= _dayIndex(b) ? a : b;

DateTime _maxDay(DateTime a, DateTime b) =>
    _dayIndex(a) >= _dayIndex(b) ? a : b;

bool _monthSelectable(DateTime month, DateTime? firstDate, DateTime? lastDate) {
  final start = DateTime(month.year, month.month, 1);
  final end = DateTime(month.year, month.month + 1, 0);
  if (firstDate != null && _isAfterDay(firstDate, end)) {
    return false;
  }
  if (lastDate != null && _isBeforeDay(lastDate, start)) {
    return false;
  }
  return true;
}

bool _yearSelectable(int year, DateTime? firstDate, DateTime? lastDate) {
  if (firstDate != null && year < firstDate.year) {
    return false;
  }
  if (lastDate != null && year > lastDate.year) {
    return false;
  }
  return true;
}

bool _daySelectable(DateTime date, DateTime? firstDate, DateTime? lastDate) {
  if (firstDate != null && _isBeforeDay(date, firstDate)) {
    return false;
  }
  if (lastDate != null && _isAfterDay(date, lastDate)) {
    return false;
  }
  return true;
}

String _localeName(BuildContext context) =>
    Localizations.localeOf(context).toString();

DateFormat _dateFormat(BuildContext context, DateFormat? format) =>
    format ?? DateFormat.yMMMd(_localeName(context));

DateFormat _monthFormat(BuildContext context, DateFormat? format) =>
    format ?? DateFormat.yMMMM(_localeName(context));

DateFormat _yearFormat(BuildContext context, DateFormat? format) =>
    format ?? DateFormat.y(_localeName(context));

DateFormat _monthNameFormat(BuildContext context) =>
    DateFormat.MMMM(_localeName(context));
