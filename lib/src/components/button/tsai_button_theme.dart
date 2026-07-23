import 'package:flutter/material.dart';

/// Optional global style overrides for [TsaiButton] variants.
///
/// Install this extension alongside [TsaiThemeTokens] in
/// [ThemeData.extensions]. Non-null properties in each [ButtonStyle] override
/// the design-system defaults.
@immutable
final class TsaiButtonTheme extends ThemeExtension<TsaiButtonTheme> {
  /// Creates button style overrides.
  const TsaiButtonTheme({
    this.primary,
    this.secondary,
    this.outline,
    this.ghost,
  });

  /// Overrides for primary buttons.
  final ButtonStyle? primary;

  /// Overrides for secondary buttons.
  final ButtonStyle? secondary;

  /// Overrides for outline buttons.
  final ButtonStyle? outline;

  /// Overrides for ghost buttons.
  final ButtonStyle? ghost;

  /// Returns the nearest button theme or an empty theme.
  static TsaiButtonTheme of(BuildContext context) =>
      Theme.of(context).extension<TsaiButtonTheme>() ?? const TsaiButtonTheme();

  @override
  TsaiButtonTheme copyWith({
    ButtonStyle? primary,
    ButtonStyle? secondary,
    ButtonStyle? outline,
    ButtonStyle? ghost,
  }) => TsaiButtonTheme(
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    outline: outline ?? this.outline,
    ghost: ghost ?? this.ghost,
  );

  @override
  TsaiButtonTheme lerp(covariant TsaiButtonTheme? other, double t) {
    if (other == null || t <= 0) {
      return this;
    }
    if (t >= 1) {
      return other;
    }
    return TsaiButtonTheme(
      primary: ButtonStyle.lerp(primary, other.primary, t),
      secondary: ButtonStyle.lerp(secondary, other.secondary, t),
      outline: ButtonStyle.lerp(outline, other.outline, t),
      ghost: ButtonStyle.lerp(ghost, other.ghost, t),
    );
  }
}
