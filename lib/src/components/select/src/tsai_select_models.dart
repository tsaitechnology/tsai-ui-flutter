part of '../tsai_select.dart';

/// Presentation used when a [TsaiSelect] opens.
enum TsaiSelectPresentation {
  /// Uses a web/desktop menu, Android bottom sheet, or iOS picker.
  adaptive,

  /// Uses an anchored Flutter menu suited to web and desktop.
  menu,

  /// Uses a Material modal bottom sheet suited to Android.
  bottomSheet,

  /// Uses a modal [CupertinoPicker] suited to iOS.
  cupertinoPicker,
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
