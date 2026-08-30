part of '../tsai_date_picker.dart';

/// Visual states of a month or year [TsaiPickerTile].
enum TsaiPickerTileState {
  /// Idle tile.
  standard,

  /// Current month or year.
  current,

  /// Single selected value.
  selected,

  /// Future or otherwise blocked.
  disabled,

  /// Interior of a range.
  inRange,

  /// Inclusive range start.
  rangeStart,

  /// Inclusive range end.
  rangeEnd,
}

/// 108×44 month or year tile with an optional continuous range band.
class TsaiPickerTile extends StatelessWidget {
  /// Creates a picker tile.
  const TsaiPickerTile({
    required this.label,
    required this.state,
    super.key,
    this.onPressed,
  });

  /// Month abbreviation or year.
  final String label;

  /// Visual treatment.
  final TsaiPickerTileState state;

  /// Called when the tile is pressed. Null when disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    final colors = tokens.colors;
    final selected =
        state == TsaiPickerTileState.selected ||
        state == TsaiPickerTileState.rangeStart ||
        state == TsaiPickerTileState.rangeEnd;
    final inRange = state == TsaiPickerTileState.inRange;
    final rangeStart = state == TsaiPickerTileState.rangeStart;
    final rangeEnd = state == TsaiPickerTileState.rangeEnd;
    final showBand = inRange || rangeStart || rangeEnd;
    final textColor = switch (state) {
      TsaiPickerTileState.standard => colors.contentPrimary,
      TsaiPickerTileState.current => colors.contentAccent,
      TsaiPickerTileState.selected ||
      TsaiPickerTileState.rangeStart ||
      TsaiPickerTileState.rangeEnd => colors.contentOnActionPrimary,
      TsaiPickerTileState.inRange => colors.contentPrimary,
      TsaiPickerTileState.disabled => colors.contentTertiary,
    };
    final textStyle =
        (selected || inRange || state == TsaiPickerTileState.current)
        ? tokens.typography.bodyMediumMedium
        : tokens.typography.bodyMedium;
    return Semantics(
      button: onPressed != null,
      enabled: onPressed != null,
      selected: selected,
      label: label,
      child: SizedBox(
        width: TsaiDatePickerMetrics.tileWidth,
        height: TsaiDatePickerMetrics.tileHeight,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPressed,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              if (showBand)
                Positioned(
                  top: 0,
                  left: rangeStart ? 54 : -TsaiDatePickerMetrics.tileOverhang,
                  width: inRange
                      ? TsaiDatePickerMetrics.tileWidth +
                            TsaiDatePickerMetrics.tileOverhang * 2
                      : 64,
                  height: TsaiDatePickerMetrics.tileHeight,
                  child: ColoredBox(color: colors.actionPrimaryMuted),
                ),
              if (selected)
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.actionPrimary,
                    borderRadius: BorderRadius.circular(tokens.radii.medium),
                  ),
                  child: const SizedBox(
                    width: TsaiDatePickerMetrics.tileWidth,
                    height: TsaiDatePickerMetrics.tileHeight,
                  ),
                ),
              Text(label, style: textStyle.copyWith(color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
