part of '../tsai_date_picker.dart';

/// 3×4 grid of [TsaiPickerTile]s for months or years.
class TsaiPeriodGrid extends StatelessWidget {
  /// Creates a 342-wide period grid.
  const TsaiPeriodGrid({required this.tiles, super.key});

  /// Exactly twelve tiles in row-major order.
  final List<TsaiPickerTile> tiles;

  @override
  Widget build(BuildContext context) {
    assert(tiles.length == 12);
    return SizedBox(
      key: const ValueKey<String>('tsai-period-grid'),
      width: TsaiDatePickerMetrics.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var row = 0; row < 4; row++) ...[
            if (row > 0)
              const SizedBox(height: TsaiDatePickerMetrics.tileRowGap),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var column = 0; column < 3; column++)
                  tiles[row * 3 + column],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
