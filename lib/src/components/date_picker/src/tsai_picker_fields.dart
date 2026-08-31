part of '../tsai_date_picker.dart';

class _TsaiPickerField extends StatefulWidget {
  const _TsaiPickerField({
    required this.displayText,
    required this.placeholder,
    required this.onOpen,
    this.enabled = true,
    this.labeledPlaceholder = true,
    this.description,
    this.errorText,
    this.icon = LucideIcons.calendar,
    this.fieldKey,
  });

  final String displayText;
  final String? placeholder;
  final bool enabled;
  final bool labeledPlaceholder;
  final String? description;
  final String? errorText;
  final IconData icon;
  final Key? fieldKey;
  final Future<void> Function() onOpen;

  @override
  State<_TsaiPickerField> createState() => _TsaiPickerFieldState();
}

class _TsaiPickerFieldState extends State<_TsaiPickerField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.displayText);
  }

  @override
  void didUpdateWidget(covariant _TsaiPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.displayText != widget.displayText &&
        _controller.text != widget.displayText) {
      _controller.text = widget.displayText;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return TsaiInput(
      key: widget.fieldKey,
      controller: _controller,
      placeholder: widget.placeholder,
      labeledPlaceholder: widget.labeledPlaceholder,
      description: widget.description,
      errorText: widget.errorText,
      enabled: widget.enabled,
      readOnly: true,
      showClearButton: false,
      onTap: widget.enabled ? () => widget.onOpen() : null,
      trailingAction: Padding(
        padding: EdgeInsetsDirectional.only(end: tokens.spacing.space8),
        child: TsaiIcon(
          widget.icon,
          size: 20,
          color: widget.enabled
              ? tokens.colors.iconSecondary
              : tokens.colors.iconTertiary,
        ),
      ),
    );
  }
}

/// Form field that opens [showTsaiDatePicker] and shows the chosen day.
class TsaiDateField extends StatelessWidget {
  /// Creates a date field.
  const TsaiDateField({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.now,
    this.format,
    this.placeholder = 'Date',
    this.labeledPlaceholder = true,
    this.description,
    this.errorText,
    this.enabled = true,
  });

  /// Selected day, or null when empty.
  final DateTime? value;

  /// Called after Apply in the sheet.
  final ValueChanged<DateTime?>? onChanged;

  /// Inclusive lower bound for the sheet.
  final DateTime? firstDate;

  /// Inclusive upper bound for the sheet.
  final DateTime? lastDate;

  /// Clock forwarded to the calendar.
  final DateTime? now;

  /// Override for the field text. Defaults to `yMMMd` in the ambient locale.
  final DateFormat? format;

  /// Floating label / empty placeholder.
  final String? placeholder;

  /// Whether [placeholder] floats like [TsaiInput].
  final bool labeledPlaceholder;

  /// Helper copy under the field.
  final String? description;

  /// Error copy under the field.
  final String? errorText;

  /// Whether the field can open the sheet.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _TsaiPickerField(
      fieldKey: const ValueKey<String>('tsai-date-field'),
      displayText: value == null
          ? ''
          : _dateFormat(context, format).format(value!),
      placeholder: placeholder,
      labeledPlaceholder: labeledPlaceholder,
      description: description,
      errorText: errorText,
      enabled: enabled,
      onOpen: () async {
        final result = await showTsaiDatePicker(
          context: context,
          initialDate: value,
          firstDate: firstDate,
          lastDate: lastDate,
          now: now,
        );
        if (result != null) {
          onChanged?.call(result);
        }
      },
    );
  }
}

/// Form field that opens [showTsaiDateRangePicker].
class TsaiDateRangeField extends StatelessWidget {
  /// Creates a date-range field.
  const TsaiDateRangeField({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.now,
    this.format,
    this.placeholder = 'Period',
    this.labeledPlaceholder = true,
    this.description,
    this.errorText,
    this.enabled = true,
  });

  /// Selected inclusive range, or null when empty.
  final DateTimeRange? value;

  /// Called after Apply in the sheet.
  final ValueChanged<DateTimeRange?>? onChanged;

  /// Inclusive lower bound for the sheet.
  final DateTime? firstDate;

  /// Inclusive upper bound for the sheet.
  final DateTime? lastDate;

  /// Clock forwarded to the calendar.
  final DateTime? now;

  /// Format for each end. Defaults to `yMMMd`.
  final DateFormat? format;

  /// Floating label / empty placeholder.
  final String? placeholder;

  /// Whether [placeholder] floats like [TsaiInput].
  final bool labeledPlaceholder;

  /// Helper copy under the field.
  final String? description;

  /// Error copy under the field.
  final String? errorText;

  /// Whether the field can open the sheet.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final formatter = _dateFormat(context, format);
    final text = value == null
        ? ''
        : '${formatter.format(value!.start)} – ${formatter.format(value!.end)}';
    return _TsaiPickerField(
      fieldKey: const ValueKey<String>('tsai-date-range-field'),
      displayText: text,
      placeholder: placeholder,
      labeledPlaceholder: labeledPlaceholder,
      description: description,
      errorText: errorText,
      enabled: enabled,
      onOpen: () async {
        final result = await showTsaiDateRangePicker(
          context: context,
          initialRange: value,
          firstDate: firstDate,
          lastDate: lastDate,
          now: now,
        );
        if (result != null) {
          onChanged?.call(result);
        }
      },
    );
  }
}

/// Form field that opens [showTsaiTimePicker].
class TsaiTimeField extends StatelessWidget {
  /// Creates a time field.
  const TsaiTimeField({
    super.key,
    this.value,
    this.onChanged,
    this.minuteStep = 1,
    this.format,
    this.placeholder = 'Time',
    this.labeledPlaceholder = true,
    this.description,
    this.errorText,
    this.enabled = true,
  });

  /// Selected time of day.
  final TimeOfDay? value;

  /// Called after Apply in the sheet.
  final ValueChanged<TimeOfDay?>? onChanged;

  /// Minute increment forwarded to the wheel.
  final int minuteStep;

  /// Override for the field text. Defaults to `Hm`.
  final DateFormat? format;

  /// Floating label / empty placeholder.
  final String? placeholder;

  /// Whether [placeholder] floats like [TsaiInput].
  final bool labeledPlaceholder;

  /// Helper copy under the field.
  final String? description;

  /// Error copy under the field.
  final String? errorText;

  /// Whether the field can open the sheet.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final formatter = format ?? DateFormat.Hm(_localeName(context));
    final text = value == null
        ? ''
        : formatter.format(DateTime(1970, 1, 1, value!.hour, value!.minute));
    return _TsaiPickerField(
      fieldKey: const ValueKey<String>('tsai-time-field'),
      displayText: text,
      placeholder: placeholder,
      labeledPlaceholder: labeledPlaceholder,
      description: description,
      errorText: errorText,
      enabled: enabled,
      icon: LucideIcons.clock,
      onOpen: () async {
        final result = await showTsaiTimePicker(
          context: context,
          initialTime: value,
          minuteStep: minuteStep,
        );
        if (result != null) {
          onChanged?.call(result);
        }
      },
    );
  }
}

/// Form field that opens [showTsaiMonthPicker] (month + year, no day).
class TsaiMonthField extends StatelessWidget {
  /// Creates a month field.
  const TsaiMonthField({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.now,
    this.format,
    this.placeholder = 'Month',
    this.labeledPlaceholder = true,
    this.description,
    this.errorText,
    this.enabled = true,
  });

  /// Selected month as the first of that month.
  final DateTime? value;

  /// Called after Apply in the sheet.
  final ValueChanged<DateTime?>? onChanged;

  /// Inclusive lower bound for the sheet.
  final DateTime? firstDate;

  /// Inclusive upper bound for the sheet.
  final DateTime? lastDate;

  /// Clock forwarded to the calendar.
  final DateTime? now;

  /// Override for the field text. Defaults to `yMMMM`.
  final DateFormat? format;

  /// Floating label / empty placeholder.
  final String? placeholder;

  /// Whether [placeholder] floats like [TsaiInput].
  final bool labeledPlaceholder;

  /// Helper copy under the field.
  final String? description;

  /// Error copy under the field.
  final String? errorText;

  /// Whether the field can open the sheet.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _TsaiPickerField(
      fieldKey: const ValueKey<String>('tsai-month-field'),
      displayText: value == null
          ? ''
          : _monthFormat(context, format).format(value!),
      placeholder: placeholder,
      labeledPlaceholder: labeledPlaceholder,
      description: description,
      errorText: errorText,
      enabled: enabled,
      onOpen: () async {
        final result = await showTsaiMonthPicker(
          context: context,
          initialMonth: value,
          firstDate: firstDate,
          lastDate: lastDate,
          now: now,
        );
        if (result != null) {
          onChanged?.call(result);
        }
      },
    );
  }
}

/// Form field that opens [showTsaiYearPicker].
class TsaiYearField extends StatelessWidget {
  /// Creates a year field.
  const TsaiYearField({
    super.key,
    this.value,
    this.onChanged,
    this.firstDate,
    this.lastDate,
    this.now,
    this.format,
    this.placeholder = 'Year',
    this.labeledPlaceholder = true,
    this.description,
    this.errorText,
    this.enabled = true,
  });

  /// Selected calendar year.
  final int? value;

  /// Called after Apply in the sheet.
  final ValueChanged<int?>? onChanged;

  /// Inclusive lower bound for the sheet.
  final DateTime? firstDate;

  /// Inclusive upper bound for the sheet.
  final DateTime? lastDate;

  /// Clock forwarded to the calendar.
  final DateTime? now;

  /// Override for the field text. Defaults to `y`.
  final DateFormat? format;

  /// Floating label / empty placeholder.
  final String? placeholder;

  /// Whether [placeholder] floats like [TsaiInput].
  final bool labeledPlaceholder;

  /// Helper copy under the field.
  final String? description;

  /// Error copy under the field.
  final String? errorText;

  /// Whether the field can open the sheet.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return _TsaiPickerField(
      fieldKey: const ValueKey<String>('tsai-year-field'),
      displayText: value == null
          ? ''
          : _yearFormat(context, format).format(DateTime(value!)),
      placeholder: placeholder,
      labeledPlaceholder: labeledPlaceholder,
      description: description,
      errorText: errorText,
      enabled: enabled,
      onOpen: () async {
        final result = await showTsaiYearPicker(
          context: context,
          initialYear: value,
          firstDate: firstDate,
          lastDate: lastDate,
          now: now,
        );
        if (result != null) {
          onChanged?.call(result);
        }
      },
    );
  }
}
