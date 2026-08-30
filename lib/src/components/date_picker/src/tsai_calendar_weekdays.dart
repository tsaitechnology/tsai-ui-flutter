part of '../tsai_date_picker.dart';

/// Monday-first weekday labels for the weekly calendar.
class TsaiCalendarWeekdays extends StatelessWidget {
  /// Creates the 342×20 weekday row.
  const TsaiCalendarWeekdays({super.key});

  static const _labels = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      key: const ValueKey<String>('tsai-calendar-weekdays'),
      width: TsaiDatePickerMetrics.width,
      height: TsaiDatePickerMetrics.weekdaysHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final label in _labels)
            SizedBox(
              width: TsaiDatePickerMetrics.dayCell,
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: tokens.typography.captionSmall.copyWith(
                  color: tokens.colors.contentTertiary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
