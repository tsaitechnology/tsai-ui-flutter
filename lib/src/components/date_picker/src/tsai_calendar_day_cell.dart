part of '../tsai_date_picker.dart';

/// Visual states of a [TsaiCalendarDayCell].
enum TsaiCalendarDayCellState {
  /// Out-of-month tail with a hidden label.
  empty,

  /// In-month day, not current, not selected.
  standard,

  /// Today's date.
  today,

  /// Single selected day.
  selected,

  /// Inclusive range start.
  rangeStart,

  /// Interior of a range.
  inRange,

  /// Inclusive range end.
  rangeEnd,

  /// Future or otherwise blocked day.
  disabled,
}

/// One 44×44 day in the weekly calendar grid.
class TsaiCalendarDayCell extends StatelessWidget {
  /// Creates a day cell.
  const TsaiCalendarDayCell({
    required this.state,
    super.key,
    this.label,
    this.onPressed,
  });

  /// Number label. Hidden when [state] is empty.
  final String? label;

  /// Visual treatment.
  final TsaiCalendarDayCellState state;

  /// Called when the cell is pressed. Null when empty or disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final showLabel = state != TsaiCalendarDayCellState.empty && label != null;
    final selected =
        state == TsaiCalendarDayCellState.selected ||
        state == TsaiCalendarDayCellState.rangeStart ||
        state == TsaiCalendarDayCellState.rangeEnd;
    final inRange = state == TsaiCalendarDayCellState.inRange;
    final rangeStart = state == TsaiCalendarDayCellState.rangeStart;
    final rangeEnd = state == TsaiCalendarDayCellState.rangeEnd;
    final showBand = inRange || rangeStart || rangeEnd;
    final textColor = switch (state) {
      TsaiCalendarDayCellState.empty => colors.contentPrimary,
      TsaiCalendarDayCellState.standard => colors.contentPrimary,
      TsaiCalendarDayCellState.today => colors.contentAccent,
      TsaiCalendarDayCellState.selected ||
      TsaiCalendarDayCellState.rangeStart ||
      TsaiCalendarDayCellState.rangeEnd => colors.contentOnActionPrimary,
      TsaiCalendarDayCellState.inRange => colors.contentPrimary,
      TsaiCalendarDayCellState.disabled => colors.contentTertiary,
    };
    return Semantics(
      button: onPressed != null,
      enabled: onPressed != null,
      selected: selected,
      label: label,
      child: SizedBox(
        width: TsaiDatePickerMetrics.dayCell,
        height: TsaiDatePickerMetrics.dayCell,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (showBand)
                Positioned(
                  top: 2,
                  left: rangeStart
                      ? 22
                      : -TsaiDatePickerMetrics.dayBandOverhang,
                  width: inRange
                      ? TsaiDatePickerMetrics.dayCell +
                            TsaiDatePickerMetrics.dayBandOverhang * 2
                      : 25,
                  height: TsaiDatePickerMetrics.dayCircle,
                  child: ColoredBox(color: colors.actionPrimaryMuted),
                ),
              if (selected)
                Container(
                  width: TsaiDatePickerMetrics.dayCircle,
                  height: TsaiDatePickerMetrics.dayCircle,
                  decoration: BoxDecoration(
                    color: colors.actionPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              if (showLabel)
                Text(
                  label!,
                  style: tokens.typography.bodyMedium.copyWith(
                    color: textColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
