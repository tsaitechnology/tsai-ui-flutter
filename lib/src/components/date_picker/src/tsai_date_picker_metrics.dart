part of '../tsai_date_picker.dart';

/// Geometry from the Penpot Date picker page.
abstract final class TsaiDatePickerMetrics {
  /// Calendar, tile grid, and time wheel width.
  static const double width = 342;

  /// Day cell slot.
  static const double dayCell = 44;

  /// Selected-day accent circle.
  static const double dayCircle = 40;

  /// Gap between calendar week rows.
  static const double dayRowGap = 4;

  /// In-range band overhang past a 44-pixel day cell.
  static const double dayBandOverhang = 3;

  /// Calendar header height.
  static const double headerHeight = 44;

  /// Weekday row height.
  static const double weekdaysHeight = 20;

  /// Month/year tile.
  static const double tileWidth = 108;

  /// Month/year tile height.
  static const double tileHeight = 44;

  /// Horizontal gap between tiles so 3×108 + 2×gap = 342.
  static const double tileGap = 9;

  /// Vertical gap between tile rows (Penpot `rowGap` 8).
  static const double tileRowGap = 8;

  /// In-range band overhang past a tile.
  static const double tileOverhang = 5;

  /// Time wheel height (5 × 44).
  static const double timeHeight = 220;

  /// Time wheel row.
  static const double timeRow = 44;

  /// Hour and minute column width.
  static const double wheelWidth = 60;

  /// Colon glyph box between the wheels.
  static const double colonWidth = 12;

  /// Flex `columnGap` around the colon (12 + 12 + 12 between wheel edges).
  static const double colonGap = 12;
}
