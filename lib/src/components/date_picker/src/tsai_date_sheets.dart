part of '../tsai_date_picker.dart';

Future<T?> _showPickerSheet<T>({
  required BuildContext context,
  required String title,
  required Widget Function(void Function(T? value) setDraft) picker,
  required bool Function(T? value) canApply,
  T? initial,
}) {
  var draft = initial;
  final applyEnabled = ValueNotifier<bool>(canApply(initial));
  return showTsaiBottomSheet<T>(
    context: context,
    title: title,
    showCloseButton: false,
    secondaryAction: Builder(
      builder: (sheetContext) => TsaiButton(
        label: 'Cancel',
        variant: TsaiButtonVariant.ghost,
        isExpanded: true,
        onPressed: () => Navigator.of(sheetContext).pop(),
      ),
    ),
    primaryAction: ValueListenableBuilder<bool>(
      valueListenable: applyEnabled,
      builder: (context, enabled, _) => Builder(
        builder: (sheetContext) => TsaiButton(
          key: const ValueKey<String>('tsai-picker-apply'),
          label: 'Apply',
          isExpanded: true,
          onPressed: enabled
              ? () => Navigator.of(sheetContext).pop(draft)
              : null,
        ),
      ),
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: picker((value) {
        draft = value;
        applyEnabled.value = canApply(value);
      }),
    ),
  ).whenComplete(applyEnabled.dispose);
}

/// Opens a content-sized sheet to pick one day.
Future<DateTime?> showTsaiDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? now,
}) => _showPickerSheet<DateTime>(
  context: context,
  title: 'Select date',
  initial: initialDate == null ? null : _dateOnly(initialDate),
  canApply: (value) => value != null,
  picker: (setDraft) => TsaiCalendarPicker(
    kind: TsaiCalendarKind.date,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    now: now,
    onDateChanged: setDraft,
  ),
);

/// Opens a content-sized sheet to pick an inclusive day-to-day range.
Future<DateTimeRange?> showTsaiDateRangePicker({
  required BuildContext context,
  DateTimeRange? initialRange,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? now,
}) => _showPickerSheet<DateTimeRange>(
  context: context,
  title: 'Select period',
  initial: initialRange,
  canApply: (value) => value != null,
  picker: (setDraft) => TsaiCalendarPicker(
    kind: TsaiCalendarKind.dateRange,
    initialRange: initialRange,
    firstDate: firstDate,
    lastDate: lastDate,
    now: now,
    onRangeChanged: setDraft,
  ),
);

/// Opens a content-sized sheet to pick a month (`year` + `month`).
Future<DateTime?> showTsaiMonthPicker({
  required BuildContext context,
  DateTime? initialMonth,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? now,
}) => _showPickerSheet<DateTime>(
  context: context,
  title: 'Select month',
  initial: initialMonth == null ? null : _monthOnly(initialMonth),
  canApply: (value) => value != null,
  picker: (setDraft) => TsaiCalendarPicker(
    kind: TsaiCalendarKind.month,
    initialMonth: initialMonth,
    firstDate: firstDate,
    lastDate: lastDate,
    now: now,
    onMonthChanged: setDraft,
  ),
);

/// Opens a content-sized sheet to pick a calendar year.
Future<int?> showTsaiYearPicker({
  required BuildContext context,
  int? initialYear,
  DateTime? firstDate,
  DateTime? lastDate,
  DateTime? now,
}) => _showPickerSheet<int>(
  context: context,
  title: 'Select year',
  initial: initialYear,
  canApply: (value) => value != null,
  picker: (setDraft) => TsaiCalendarPicker(
    kind: TsaiCalendarKind.year,
    initialYear: initialYear,
    firstDate: firstDate,
    lastDate: lastDate,
    now: now,
    onYearChanged: setDraft,
  ),
);
