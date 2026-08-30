part of '../tsai_date_picker.dart';

/// A single hour or minute wheel with Penpot type ramps.
class TsaiTimeWheelColumn extends StatelessWidget {
  /// Creates a 60×220 wheel.
  const TsaiTimeWheelColumn({
    required this.itemCount,
    required this.selectedIndex,
    required this.labelForIndex,
    super.key,
    this.onSelected,
    this.controller,
  });

  /// Number of scrollable values.
  final int itemCount;

  /// Currently selected row.
  final int selectedIndex;

  /// Formats a wheel index, for example hours or minutes.
  final String Function(int index) labelForIndex;

  /// Called when the centered row changes.
  final ValueChanged<int>? onSelected;

  /// Optional scroll controller.
  final FixedExtentScrollController? controller;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      width: TsaiDatePickerMetrics.wheelWidth,
      height: TsaiDatePickerMetrics.timeHeight,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: TsaiDatePickerMetrics.timeRow,
        physics: const FixedExtentScrollPhysics(),
        perspective: 0.0001,
        diameterRatio: 100,
        onSelectedItemChanged: onSelected,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (context, index) {
            final distance = (index - selectedIndex).abs();
            final style = switch (distance) {
              0 => tokens.typography.bodyLarge.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                height: 1.2,
                color: tokens.colors.contentPrimary,
              ),
              1 => tokens.typography.bodyLarge.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: tokens.colors.contentSecondary,
              ),
              _ => tokens.typography.bodyLarge.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: tokens.colors.contentTertiary,
              ),
            };
            return Center(child: Text(labelForIndex(index), style: style));
          },
        ),
      ),
    );
  }
}

/// 342×220 hour and minute wheels with an indigo highlight row.
class TsaiTimeWheel extends StatelessWidget {
  /// Creates the Penpot Time Picker wheel.
  const TsaiTimeWheel({
    required this.hour,
    required this.minute,
    super.key,
    this.minuteStep = 1,
    this.onHourChanged,
    this.onMinuteChanged,
    this.hourController,
    this.minuteController,
  });

  /// Selected hour in 24h, 0–23.
  final int hour;

  /// Selected minute, 0–59, aligned to [minuteStep].
  final int minute;

  /// Minute increment. Penpot allows 1, 5, or 15.
  final int minuteStep;

  /// Called when the hour wheel settles.
  final ValueChanged<int>? onHourChanged;

  /// Called when the minute wheel settles, with the actual minute value.
  final ValueChanged<int>? onMinuteChanged;

  /// Optional hour scroll controller.
  final FixedExtentScrollController? hourController;

  /// Optional minute scroll controller.
  final FixedExtentScrollController? minuteController;

  int get _minuteCount => 60 ~/ minuteStep;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return SizedBox(
      key: const ValueKey<String>('tsai-time-wheel'),
      width: TsaiDatePickerMetrics.width,
      height: TsaiDatePickerMetrics.timeHeight,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            height: TsaiDatePickerMetrics.timeRow,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tokens.colors.surfaceAccent,
                borderRadius: BorderRadius.circular(tokens.radii.medium),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TsaiTimeWheelColumn(
                key: const ValueKey<String>('tsai-time-hour'),
                controller: hourController,
                itemCount: 24,
                selectedIndex: hour,
                labelForIndex: (index) => '$index',
                onSelected: onHourChanged,
              ),
              const TsaiTimeColon(),
              TsaiTimeWheelColumn(
                key: const ValueKey<String>('tsai-time-minute'),
                controller: minuteController,
                itemCount: _minuteCount,
                selectedIndex: minute ~/ minuteStep,
                labelForIndex: (index) => '${index * minuteStep}',
                onSelected: (index) =>
                    onMinuteChanged?.call(index * minuteStep),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
