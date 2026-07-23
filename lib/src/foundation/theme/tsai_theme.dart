import 'package:flutter/material.dart';

import '../semantic/tsai_theme_tokens.dart';

/// Installs canonical Tsai token sets into consumer-owned [ThemeData].
abstract final class TsaiTheme {
  /// Creates a light theme while preserving unrelated extensions from [base].
  static ThemeData light({ThemeData? base}) =>
      _install(base ?? ThemeData.light(), TsaiThemeTokens.light);

  /// Creates a dark theme while preserving unrelated extensions from [base].
  static ThemeData dark({ThemeData? base}) =>
      _install(base ?? ThemeData.dark(), TsaiThemeTokens.dark);

  static ThemeData _install(ThemeData base, TsaiThemeTokens tokens) {
    final colors = tokens.colors;
    final brightness = colors.canvas.computeLuminance() > 0.5
        ? Brightness.light
        : Brightness.dark;
    return base.copyWith(
      brightness: brightness,
      scaffoldBackgroundColor: colors.canvas,
      canvasColor: colors.canvas,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: colors.actionPrimary,
        onPrimary: colors.contentOnActionPrimary,
        surface: colors.surface,
        onSurface: colors.contentPrimary,
        error: colors.negative,
        outline: colors.borderStrong,
        outlineVariant: colors.borderSubtle,
      ),
      textTheme: _textTheme(tokens),
      extensions: [
        ...base.extensions.values.where((value) => value is! TsaiThemeTokens),
        tokens,
      ],
    );
  }

  static TextTheme _textTheme(TsaiThemeTokens tokens) {
    final type = tokens.typography;
    final color = tokens.colors.contentPrimary;
    return TextTheme(
      displayLarge: type.headingExtraLarge.copyWith(color: color),
      headlineLarge: type.headingLarge.copyWith(color: color),
      headlineMedium: type.headingMedium.copyWith(color: color),
      headlineSmall: type.headingSmall.copyWith(color: color),
      bodyLarge: type.bodyLarge.copyWith(color: color),
      bodyMedium: type.bodyMedium.copyWith(color: color),
      labelLarge: type.buttonLarge.copyWith(color: color),
      labelMedium: type.buttonMedium.copyWith(color: color),
      labelSmall: type.captionSmall.copyWith(color: color),
    );
  }
}
