part of '../tsai_button.dart';

/// Visual variants defined by the Penpot button component.
enum TsaiButtonVariant {
  /// High-emphasis filled action.
  primary,

  /// Accent-tinted filled action.
  secondary,

  /// Transparent action with a border.
  outline,

  /// Transparent action without a border.
  ghost,
}

/// Semantic color treatments supported by every button variant.
enum TsaiButtonTone {
  /// Standard accent or neutral treatment.
  standard,

  /// Destructive treatment for irreversible or high-risk actions.
  danger,
}

/// Visual sizes defined by the Penpot button component.
enum TsaiButtonSize {
  /// A 40-pixel visual control with a padded touch target.
  medium,

  /// A 56-pixel visual control.
  large,
}
