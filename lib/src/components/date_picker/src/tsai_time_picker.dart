part of '../tsai_date_picker.dart';

/// Time-of-day picker using [TsaiTimeWheel].
class TsaiTimePicker extends StatefulWidget {
  /// Creates a time picker.
  const TsaiTimePicker({
    super.key,
    this.initialTime,
    this.minuteStep = 1,
    this.onChanged,
  }) : assert(minuteStep == 1 || minuteStep == 5 || minuteStep == 15);

  /// Initial selection. Defaults to 15:30 to match the Penpot main.
  final TimeOfDay? initialTime;

  /// Minute increment: 1, 5, or 15.
  final int minuteStep;

  /// Called whenever either wheel settles.
  final ValueChanged<TimeOfDay>? onChanged;

  @override
  State<TsaiTimePicker> createState() => _TsaiTimePickerState();
}

class _TsaiTimePickerState extends State<TsaiTimePicker> {
  late int _hour;
  late int _minute;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialTime ?? const TimeOfDay(hour: 15, minute: 30);
    _hour = initial.hour;
    _minute = initial.minute - initial.minute % widget.minuteStep;
    _hourController = FixedExtentScrollController(initialItem: _hour);
    _minuteController = FixedExtentScrollController(
      initialItem: _minute ~/ widget.minuteStep,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TsaiTimeWheel(
      hour: _hour,
      minute: _minute,
      minuteStep: widget.minuteStep,
      hourController: _hourController,
      minuteController: _minuteController,
      onHourChanged: (value) {
        setState(() => _hour = value);
        widget.onChanged?.call(TimeOfDay(hour: _hour, minute: _minute));
      },
      onMinuteChanged: (value) {
        setState(() => _minute = value);
        widget.onChanged?.call(TimeOfDay(hour: _hour, minute: _minute));
      },
    );
  }
}

/// Opens a bottom sheet titled `Select time` with Cancel / Apply.
Future<TimeOfDay?> showTsaiTimePicker({
  required BuildContext context,
  TimeOfDay? initialTime,
  int minuteStep = 1,
}) {
  var draft = initialTime ?? const TimeOfDay(hour: 15, minute: 30);
  return showTsaiBottomSheet<TimeOfDay>(
    context: context,
    title: 'Select time',
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
        key: const ValueKey<String>('tsai-picker-apply'),
        label: 'Apply',
        isExpanded: true,
        onPressed: () => Navigator.of(sheetContext).pop(draft),
      ),
    ),
    child: Align(
      alignment: Alignment.topCenter,
      child: TsaiTimePicker(
        initialTime: initialTime,
        minuteStep: minuteStep,
        onChanged: (value) => draft = value,
      ),
    ),
  );
}
