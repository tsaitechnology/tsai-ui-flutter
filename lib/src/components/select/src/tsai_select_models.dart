part of '../tsai_select.dart';

/// Presentation used when a [TsaiSelect] opens.
enum TsaiSelectPresentation {
  /// Opens options in a [TsaiBottomSheet].
  adaptive,

  /// Legacy value. Options still open in a [TsaiBottomSheet].
  menu,

  /// Opens options in a [TsaiBottomSheet].
  bottomSheet,
}

/// A selectable value shown by [TsaiSelect].
@immutable
final class TsaiSelectOption<T> {
  /// Creates a select option.
  const TsaiSelectOption({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
  });

  /// Value delivered to [TsaiSelect.onChanged].
  final T value;

  /// Visible option label.
  final String label;

  /// Optional leading icon.
  final TsaiIcon? icon;

  /// Whether this option can be selected.
  final bool enabled;
}
