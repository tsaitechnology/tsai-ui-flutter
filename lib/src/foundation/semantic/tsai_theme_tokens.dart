import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../primitives/reference_tokens.dart';

/// The complete semantic token schema consumed by Tsai components.
@immutable
final class TsaiThemeTokens extends ThemeExtension<TsaiThemeTokens> {
  const TsaiThemeTokens._({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radii,
    required this.borders,
    required this.shadows,
  });

  /// Canonical light token set sourced from Penpot.
  static final light = _fromReference(
    TsaiReferenceTokens.lightColors,
    const TsaiShadowTokens(
      soft: BoxShadow(
        color: Color(0x1A000000),
        offset: Offset(0, 16),
        blurRadius: 40,
      ),
      accentGlow: BoxShadow(
        color: Color(0x336366F1),
        offset: Offset(0, 14),
        blurRadius: 44,
      ),
    ),
  );

  /// Canonical dark token set sourced from Penpot.
  static final dark = _fromReference(
    TsaiReferenceTokens.darkColors,
    const TsaiShadowTokens(
      soft: BoxShadow(
        color: Color(0x80000000),
        offset: Offset(0, 16),
        blurRadius: 40,
      ),
      accentGlow: BoxShadow(
        color: Color(0x476366F1),
        offset: Offset(0, 14),
        blurRadius: 44,
      ),
    ),
  );

  /// Intent-based colors for surfaces, content, actions, borders, and icons.
  final TsaiColorTokens colors;

  /// Role-based Inter and JetBrains Mono text styles.
  final TsaiTypographyTokens typography;

  /// The shared 2 to 80 pixel spacing scale.
  final TsaiSpacingTokens spacing;

  /// The shared corner-radius scale.
  final TsaiRadiusTokens radii;

  /// Semantic border widths.
  final TsaiBorderTokens borders;

  /// Semantic elevation effects.
  final TsaiShadowTokens shadows;

  /// Returns the nearest installed Tsai tokens.
  ///
  /// Throws a [FlutterError] when [TsaiThemeTokens] is not installed.
  static TsaiThemeTokens of(BuildContext context) {
    final tokens = maybeOf(context);
    if (tokens == null) {
      throw FlutterError(
        'No TsaiThemeTokens found. Install TsaiTheme.light() or '
        'TsaiTheme.dark() in MaterialApp.',
      );
    }
    return tokens;
  }

  /// Returns the nearest installed Tsai tokens, if any.
  static TsaiThemeTokens? maybeOf(BuildContext context) =>
      Theme.of(context).extension<TsaiThemeTokens>();

  @override
  TsaiThemeTokens copyWith({
    TsaiColorTokens? colors,
    TsaiTypographyTokens? typography,
    TsaiSpacingTokens? spacing,
    TsaiRadiusTokens? radii,
    TsaiBorderTokens? borders,
    TsaiShadowTokens? shadows,
  }) => TsaiThemeTokens._(
    colors: colors ?? this.colors,
    typography: typography ?? this.typography,
    spacing: spacing ?? this.spacing,
    radii: radii ?? this.radii,
    borders: borders ?? this.borders,
    shadows: shadows ?? this.shadows,
  );

  @override
  TsaiThemeTokens lerp(covariant TsaiThemeTokens? other, double t) {
    if (other == null || t <= 0) {
      return this;
    }
    if (t >= 1) {
      return other;
    }
    return TsaiThemeTokens._(
      colors: colors.lerp(other.colors, t),
      typography: typography.lerp(other.typography, t),
      spacing: spacing.lerp(other.spacing, t),
      radii: radii.lerp(other.radii, t),
      borders: borders.lerp(other.borders, t),
      shadows: shadows.lerp(other.shadows, t),
    );
  }

  static TsaiThemeTokens _fromReference(
    TsaiReferenceColors colors,
    TsaiShadowTokens shadows,
  ) => TsaiThemeTokens._(
    colors: TsaiColorTokens(
      canvas: colors.background,
      surface: colors.surface1,
      surfaceRaised: colors.surface2,
      surfaceAccent: colors.surfaceIndigo,
      surfaceAccentPressed: colors.surfaceIndigoDeep,
      contentPrimary: colors.textPrimary,
      contentSecondary: colors.textSecondary,
      contentTertiary: colors.textTertiary,
      contentOnActionPrimary: colors.textOnAccentPrimary,
      contentOnActionSecondary: colors.textOnAccentSecondary,
      actionPrimary: colors.accent,
      actionPrimaryPressed: colors.accentDeep,
      actionPrimarySoft: colors.accentLight,
      positive: colors.gain,
      negative: colors.loss,
      borderSubtle: colors.borderHairline,
      borderStrong: colors.borderStrong,
      iconPrimary: colors.iconPrimary,
      iconSecondary: colors.iconSecondary,
      iconTertiary: colors.iconTertiary,
      iconOnAction: colors.iconOnAccent,
      iconBright: colors.iconBright,
    ),
    typography: TsaiTypographyTokens.standard,
    spacing: TsaiSpacingTokens.standard,
    radii: TsaiRadiusTokens.standard,
    borders: const TsaiBorderTokens(hairline: 1),
    shadows: shadows,
  );
}

/// Semantic color roles shared by all components.
@immutable
final class TsaiColorTokens {
  /// Creates a complete set of semantic colors.
  const TsaiColorTokens({
    required this.canvas,
    required this.surface,
    required this.surfaceRaised,
    required this.surfaceAccent,
    required this.surfaceAccentPressed,
    required this.contentPrimary,
    required this.contentSecondary,
    required this.contentTertiary,
    required this.contentOnActionPrimary,
    required this.contentOnActionSecondary,
    required this.actionPrimary,
    required this.actionPrimaryPressed,
    required this.actionPrimarySoft,
    required this.positive,
    required this.negative,
    required this.borderSubtle,
    required this.borderStrong,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconTertiary,
    required this.iconOnAction,
    required this.iconBright,
  });

  /// Application canvas.
  final Color canvas;

  /// Default contained surface.
  final Color surface;

  /// Raised or emphasized surface.
  final Color surfaceRaised;

  /// Accent-tinted surface.
  final Color surfaceAccent;

  /// Pressed accent-tinted surface.
  final Color surfaceAccentPressed;

  /// Primary text content.
  final Color contentPrimary;

  /// Secondary text content.
  final Color contentSecondary;

  /// Disabled or tertiary text content.
  final Color contentTertiary;

  /// Primary content placed over a primary action.
  final Color contentOnActionPrimary;

  /// Secondary content placed over a primary action.
  final Color contentOnActionSecondary;

  /// Primary interactive action.
  final Color actionPrimary;

  /// Pressed primary interactive action.
  final Color actionPrimaryPressed;

  /// Lighter accent used for focus and emphasis.
  final Color actionPrimarySoft;

  /// Positive status.
  final Color positive;

  /// Negative or error status.
  final Color negative;

  /// Subtle border.
  final Color borderSubtle;

  /// Strong border.
  final Color borderStrong;

  /// Primary icon.
  final Color iconPrimary;

  /// Secondary icon.
  final Color iconSecondary;

  /// Disabled or tertiary icon.
  final Color iconTertiary;

  /// Icon placed over a primary action.
  final Color iconOnAction;

  /// Bright accent icon.
  final Color iconBright;

  /// Interpolates every color role.
  TsaiColorTokens lerp(TsaiColorTokens other, double t) => TsaiColorTokens(
    canvas: Color.lerp(canvas, other.canvas, t)!,
    surface: Color.lerp(surface, other.surface, t)!,
    surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
    surfaceAccent: Color.lerp(surfaceAccent, other.surfaceAccent, t)!,
    surfaceAccentPressed: Color.lerp(
      surfaceAccentPressed,
      other.surfaceAccentPressed,
      t,
    )!,
    contentPrimary: Color.lerp(contentPrimary, other.contentPrimary, t)!,
    contentSecondary: Color.lerp(contentSecondary, other.contentSecondary, t)!,
    contentTertiary: Color.lerp(contentTertiary, other.contentTertiary, t)!,
    contentOnActionPrimary: Color.lerp(
      contentOnActionPrimary,
      other.contentOnActionPrimary,
      t,
    )!,
    contentOnActionSecondary: Color.lerp(
      contentOnActionSecondary,
      other.contentOnActionSecondary,
      t,
    )!,
    actionPrimary: Color.lerp(actionPrimary, other.actionPrimary, t)!,
    actionPrimaryPressed: Color.lerp(
      actionPrimaryPressed,
      other.actionPrimaryPressed,
      t,
    )!,
    actionPrimarySoft: Color.lerp(
      actionPrimarySoft,
      other.actionPrimarySoft,
      t,
    )!,
    positive: Color.lerp(positive, other.positive, t)!,
    negative: Color.lerp(negative, other.negative, t)!,
    borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
    borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
    iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
    iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
    iconTertiary: Color.lerp(iconTertiary, other.iconTertiary, t)!,
    iconOnAction: Color.lerp(iconOnAction, other.iconOnAction, t)!,
    iconBright: Color.lerp(iconBright, other.iconBright, t)!,
  );
}

/// Semantic typography roles sourced from the Penpot typography set.
@immutable
final class TsaiTypographyTokens {
  /// Creates a complete typography set.
  const TsaiTypographyTokens({
    required this.headingExtraLarge,
    required this.headingLarge,
    required this.headingMedium,
    required this.headingSmall,
    required this.bodyLargeMedium,
    required this.bodyLarge,
    required this.bodyMediumMedium,
    required this.bodyMedium,
    required this.buttonLarge,
    required this.buttonMedium,
    required this.captionMedium,
    required this.captionMediumRegular,
    required this.captionSmall,
    required this.captionSmallRegular,
    required this.monoHeadingExtraLarge,
    required this.monoHeadingLarge,
    required this.monoBodyLarge,
    required this.monoBodyMedium,
    required this.monoCaption,
    required this.monoCaptionRegular,
  });

  /// Canonical typography values sourced from Penpot.
  static const standard = TsaiTypographyTokens(
    headingExtraLarge: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 32,
      fontWeight: FontWeight.w600,
      height: 1.1875,
    ),
    headingLarge: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.1667,
    ),
    headingMedium: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.2,
    ),
    headingSmall: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.2222,
    ),
    bodyLargeMedium: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.25,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 16,
      height: 1.25,
    ),
    bodyMediumMedium: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.1429,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 14,
      height: 1.1429,
    ),
    buttonLarge: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.25,
    ),
    buttonMedium: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.1429,
    ),
    captionMedium: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.2308,
    ),
    captionMediumRegular: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 13,
      height: 1.2308,
    ),
    captionSmall: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.2727,
    ),
    captionSmallRegular: TextStyle(
      fontFamily: 'Inter',
      package: 'tsai_ui',
      fontSize: 11,
      height: 1.2727,
    ),
    monoHeadingExtraLarge: TextStyle(
      fontFamily: 'JetBrains Mono',
      package: 'tsai_ui',
      fontSize: 36,
      fontWeight: FontWeight.w600,
      height: 1.2222,
    ),
    monoHeadingLarge: TextStyle(
      fontFamily: 'JetBrains Mono',
      package: 'tsai_ui',
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 1.1667,
    ),
    monoBodyLarge: TextStyle(
      fontFamily: 'JetBrains Mono',
      package: 'tsai_ui',
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.25,
    ),
    monoBodyMedium: TextStyle(
      fontFamily: 'JetBrains Mono',
      package: 'tsai_ui',
      fontSize: 14,
      height: 1.1429,
    ),
    monoCaption: TextStyle(
      fontFamily: 'JetBrains Mono',
      package: 'tsai_ui',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.2308,
    ),
    monoCaptionRegular: TextStyle(
      fontFamily: 'JetBrains Mono',
      package: 'tsai_ui',
      fontSize: 13,
      height: 1.2308,
    ),
  );

  /// Extra-large UI heading.
  final TextStyle headingExtraLarge;

  /// Large UI heading.
  final TextStyle headingLarge;

  /// Medium UI heading.
  final TextStyle headingMedium;

  /// Small UI heading.
  final TextStyle headingSmall;

  /// Medium-weight large body text.
  final TextStyle bodyLargeMedium;

  /// Regular large body text.
  final TextStyle bodyLarge;

  /// Medium-weight medium body text.
  final TextStyle bodyMediumMedium;

  /// Regular medium body text.
  final TextStyle bodyMedium;

  /// Large button label.
  final TextStyle buttonLarge;

  /// Medium button label.
  final TextStyle buttonMedium;

  /// Medium-weight caption.
  final TextStyle captionMedium;

  /// Regular caption.
  final TextStyle captionMediumRegular;

  /// Medium-weight small caption.
  final TextStyle captionSmall;

  /// Regular small caption.
  final TextStyle captionSmallRegular;

  /// Extra-large monospaced heading.
  final TextStyle monoHeadingExtraLarge;

  /// Large monospaced heading.
  final TextStyle monoHeadingLarge;

  /// Large monospaced body text.
  final TextStyle monoBodyLarge;

  /// Medium monospaced body text.
  final TextStyle monoBodyMedium;

  /// Medium-weight monospaced caption.
  final TextStyle monoCaption;

  /// Regular monospaced caption.
  final TextStyle monoCaptionRegular;

  /// Interpolates every typography role.
  TsaiTypographyTokens lerp(TsaiTypographyTokens other, double t) {
    TextStyle style(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return TsaiTypographyTokens(
      headingExtraLarge: style(headingExtraLarge, other.headingExtraLarge),
      headingLarge: style(headingLarge, other.headingLarge),
      headingMedium: style(headingMedium, other.headingMedium),
      headingSmall: style(headingSmall, other.headingSmall),
      bodyLargeMedium: style(bodyLargeMedium, other.bodyLargeMedium),
      bodyLarge: style(bodyLarge, other.bodyLarge),
      bodyMediumMedium: style(bodyMediumMedium, other.bodyMediumMedium),
      bodyMedium: style(bodyMedium, other.bodyMedium),
      buttonLarge: style(buttonLarge, other.buttonLarge),
      buttonMedium: style(buttonMedium, other.buttonMedium),
      captionMedium: style(captionMedium, other.captionMedium),
      captionMediumRegular: style(
        captionMediumRegular,
        other.captionMediumRegular,
      ),
      captionSmall: style(captionSmall, other.captionSmall),
      captionSmallRegular: style(
        captionSmallRegular,
        other.captionSmallRegular,
      ),
      monoHeadingExtraLarge: style(
        monoHeadingExtraLarge,
        other.monoHeadingExtraLarge,
      ),
      monoHeadingLarge: style(monoHeadingLarge, other.monoHeadingLarge),
      monoBodyLarge: style(monoBodyLarge, other.monoBodyLarge),
      monoBodyMedium: style(monoBodyMedium, other.monoBodyMedium),
      monoCaption: style(monoCaption, other.monoCaption),
      monoCaptionRegular: style(monoCaptionRegular, other.monoCaptionRegular),
    );
  }
}

/// Direction-neutral layout spacing values.
@immutable
final class TsaiSpacingTokens {
  /// Creates a complete spacing scale.
  const TsaiSpacingTokens({
    required this.space2,
    required this.space4,
    required this.space8,
    required this.space16,
    required this.space20,
    required this.space24,
    required this.space32,
    required this.space48,
    required this.space64,
    required this.space80,
  });

  /// Canonical spacing values sourced from Penpot.
  static const standard = TsaiSpacingTokens(
    space2: 2,
    space4: 4,
    space8: 8,
    space16: 16,
    space20: 20,
    space24: 24,
    space32: 32,
    space48: 48,
    space64: 64,
    space80: 80,
  );

  /// Two pixels.
  final double space2;

  /// Four pixels.
  final double space4;

  /// Eight pixels.
  final double space8;

  /// Sixteen pixels.
  final double space16;

  /// Twenty pixels.
  final double space20;

  /// Twenty-four pixels.
  final double space24;

  /// Thirty-two pixels.
  final double space32;

  /// Forty-eight pixels.
  final double space48;

  /// Sixty-four pixels.
  final double space64;

  /// Eighty pixels.
  final double space80;

  /// Interpolates every spacing value.
  TsaiSpacingTokens lerp(TsaiSpacingTokens other, double t) =>
      TsaiSpacingTokens(
        space2: lerpDouble(space2, other.space2, t)!,
        space4: lerpDouble(space4, other.space4, t)!,
        space8: lerpDouble(space8, other.space8, t)!,
        space16: lerpDouble(space16, other.space16, t)!,
        space20: lerpDouble(space20, other.space20, t)!,
        space24: lerpDouble(space24, other.space24, t)!,
        space32: lerpDouble(space32, other.space32, t)!,
        space48: lerpDouble(space48, other.space48, t)!,
        space64: lerpDouble(space64, other.space64, t)!,
        space80: lerpDouble(space80, other.space80, t)!,
      );
}

/// Corner-radius values sourced from Penpot.
@immutable
final class TsaiRadiusTokens {
  /// Creates a complete corner-radius scale.
  const TsaiRadiusTokens({
    required this.small,
    required this.medium,
    required this.large,
    required this.extraLarge,
    required this.pill,
  });

  /// Canonical radius values sourced from Penpot.
  static const standard = TsaiRadiusTokens(
    small: 6,
    medium: 12,
    large: 16,
    extraLarge: 24,
    pill: 999,
  );

  /// Six-pixel radius.
  final double small;

  /// Twelve-pixel radius.
  final double medium;

  /// Sixteen-pixel radius.
  final double large;

  /// Twenty-four-pixel radius.
  final double extraLarge;

  /// Fully rounded radius.
  final double pill;

  /// Interpolates every radius value.
  TsaiRadiusTokens lerp(TsaiRadiusTokens other, double t) => TsaiRadiusTokens(
    small: lerpDouble(small, other.small, t)!,
    medium: lerpDouble(medium, other.medium, t)!,
    large: lerpDouble(large, other.large, t)!,
    extraLarge: lerpDouble(extraLarge, other.extraLarge, t)!,
    pill: lerpDouble(pill, other.pill, t)!,
  );
}

/// Border-width values sourced from Penpot.
@immutable
final class TsaiBorderTokens {
  /// Creates border tokens.
  const TsaiBorderTokens({required this.hairline});

  /// One-pixel border.
  final double hairline;

  /// Interpolates every border-width value.
  TsaiBorderTokens lerp(TsaiBorderTokens other, double t) =>
      TsaiBorderTokens(hairline: lerpDouble(hairline, other.hairline, t)!);
}

/// Theme-aware shadows sourced from Penpot.
@immutable
final class TsaiShadowTokens {
  /// Creates a complete shadow set.
  const TsaiShadowTokens({required this.soft, required this.accentGlow});

  /// Soft raised-surface shadow.
  final BoxShadow soft;

  /// Accent glow shadow.
  final BoxShadow accentGlow;

  /// Interpolates every shadow.
  TsaiShadowTokens lerp(TsaiShadowTokens other, double t) => TsaiShadowTokens(
    soft: BoxShadow.lerp(soft, other.soft, t)!,
    accentGlow: BoxShadow.lerp(accentGlow, other.accentGlow, t)!,
  );
}
