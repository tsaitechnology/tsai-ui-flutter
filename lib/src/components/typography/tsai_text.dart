import 'package:flutter/material.dart';

import '../../foundation/semantic/tsai_theme_tokens.dart';

/// Sizes available to [TsaiTextHeading].
enum TsaiHeadingSize {
  /// 32-pixel Inter heading.
  extraLarge,

  /// 24-pixel Inter heading.
  large,

  /// 20-pixel Inter heading.
  medium,

  /// 18-pixel Inter heading.
  small,
}

/// Sizes available to Inter and monospaced body text.
enum TsaiBodySize {
  /// 16-pixel body text.
  large,

  /// 14-pixel body text.
  medium,
}

/// Semantic text weights exposed by body and caption roles.
enum TsaiTextWeight {
  /// Regular text.
  regular,

  /// Medium-emphasis text.
  medium,
}

/// Sizes available to [TsaiTextButton].
enum TsaiButtonTextSize {
  /// 16-pixel button label.
  large,

  /// 14-pixel button label.
  medium,
}

/// Sizes available to [TsaiTextCaption].
enum TsaiCaptionSize {
  /// 13-pixel caption.
  medium,

  /// 11-pixel caption.
  small,
}

/// Sizes available to [TsaiTextMonoHeading].
enum TsaiMonoHeadingSize {
  /// 36-pixel JetBrains Mono heading.
  extraLarge,

  /// 24-pixel JetBrains Mono heading.
  large,
}

/// Four-size Inter heading from the Tsai typography system.
final class TsaiTextHeading extends TsaiText {
  /// Creates an Inter heading.
  const TsaiTextHeading(
    super.data, {
    required this.size,
    super.key,
    super.color,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.softWrap,
    super.textScaler,
    super.semanticsLabel,
  });

  /// Typography size.
  final TsaiHeadingSize size;

  @override
  TextStyle _resolveStyle(TsaiTypographyTokens tokens) => switch (size) {
    TsaiHeadingSize.extraLarge => tokens.headingExtraLarge,
    TsaiHeadingSize.large => tokens.headingLarge,
    TsaiHeadingSize.medium => tokens.headingMedium,
    TsaiHeadingSize.small => tokens.headingSmall,
  };
}

/// Four-role Inter body text from the Tsai typography system.
final class TsaiTextBody extends TsaiText {
  /// Creates Inter body text.
  const TsaiTextBody(
    super.data, {
    required this.size,
    required this.weight,
    super.key,
    super.color,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.softWrap,
    super.textScaler,
    super.semanticsLabel,
  });

  /// Typography size.
  final TsaiBodySize size;

  /// Typography weight.
  final TsaiTextWeight weight;

  @override
  TextStyle _resolveStyle(TsaiTypographyTokens tokens) =>
      switch ((size, weight)) {
        (TsaiBodySize.large, TsaiTextWeight.medium) => tokens.bodyLargeMedium,
        (TsaiBodySize.large, TsaiTextWeight.regular) => tokens.bodyLarge,
        (TsaiBodySize.medium, TsaiTextWeight.medium) => tokens.bodyMediumMedium,
        (TsaiBodySize.medium, TsaiTextWeight.regular) => tokens.bodyMedium,
      };
}

/// Two-size Inter button label from the Tsai typography system.
final class TsaiTextButton extends TsaiText {
  /// Creates an Inter button label.
  const TsaiTextButton(
    super.data, {
    required this.size,
    super.key,
    super.color,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.softWrap,
    super.textScaler,
    super.semanticsLabel,
  });

  /// Typography size.
  final TsaiButtonTextSize size;

  @override
  TextStyle _resolveStyle(TsaiTypographyTokens tokens) => switch (size) {
    TsaiButtonTextSize.large => tokens.buttonLarge,
    TsaiButtonTextSize.medium => tokens.buttonMedium,
  };
}

/// Four-role Inter caption from the Tsai typography system.
final class TsaiTextCaption extends TsaiText {
  /// Creates an Inter caption.
  const TsaiTextCaption(
    super.data, {
    required this.size,
    required this.weight,
    super.key,
    super.color,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.softWrap,
    super.textScaler,
    super.semanticsLabel,
  });

  /// Typography size.
  final TsaiCaptionSize size;

  /// Typography weight.
  final TsaiTextWeight weight;

  @override
  TextStyle _resolveStyle(TsaiTypographyTokens tokens) =>
      switch ((size, weight)) {
        (TsaiCaptionSize.medium, TsaiTextWeight.medium) => tokens.captionMedium,
        (TsaiCaptionSize.medium, TsaiTextWeight.regular) =>
          tokens.captionMediumRegular,
        (TsaiCaptionSize.small, TsaiTextWeight.medium) => tokens.captionSmall,
        (TsaiCaptionSize.small, TsaiTextWeight.regular) =>
          tokens.captionSmallRegular,
      };

  @override
  String get _displayData =>
      size == TsaiCaptionSize.small ? data.toUpperCase() : data;
}

/// Two-size JetBrains Mono heading from the Tsai typography system.
final class TsaiTextMonoHeading extends TsaiText {
  /// Creates a monospaced heading.
  const TsaiTextMonoHeading(
    super.data, {
    required this.size,
    super.key,
    super.color,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.softWrap,
    super.textScaler,
    super.semanticsLabel,
  });

  /// Typography size.
  final TsaiMonoHeadingSize size;

  @override
  TextStyle _resolveStyle(TsaiTypographyTokens tokens) => switch (size) {
    TsaiMonoHeadingSize.extraLarge => tokens.monoHeadingExtraLarge,
    TsaiMonoHeadingSize.large => tokens.monoHeadingLarge,
  };
}

/// Two-size JetBrains Mono body text from the Tsai typography system.
final class TsaiTextMonoBody extends TsaiText {
  /// Creates monospaced body text.
  const TsaiTextMonoBody(
    super.data, {
    required this.size,
    super.key,
    super.color,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.softWrap,
    super.textScaler,
    super.semanticsLabel,
  });

  /// Typography size.
  final TsaiBodySize size;

  @override
  TextStyle _resolveStyle(TsaiTypographyTokens tokens) => switch (size) {
    TsaiBodySize.large => tokens.monoBodyLarge,
    TsaiBodySize.medium => tokens.monoBodyMedium,
  };
}

/// Two-weight JetBrains Mono caption from the Tsai typography system.
final class TsaiTextMonoCaption extends TsaiText {
  /// Creates a monospaced caption.
  const TsaiTextMonoCaption(
    super.data, {
    required this.weight,
    super.key,
    super.color,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.softWrap,
    super.textScaler,
    super.semanticsLabel,
  });

  /// Typography weight.
  final TsaiTextWeight weight;

  @override
  TextStyle _resolveStyle(TsaiTypographyTokens tokens) => switch (weight) {
    TsaiTextWeight.medium => tokens.monoCaption,
    TsaiTextWeight.regular => tokens.monoCaptionRegular,
  };
}

/// Base class for text widgets backed by a valid Tsai typography role.
sealed class TsaiText extends StatelessWidget {
  const TsaiText(
    this.data, {
    super.key,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.softWrap,
    this.textScaler,
    this.semanticsLabel,
  });

  /// Text to display.
  final String data;

  /// Optional semantic color override.
  final Color? color;

  /// How the text is aligned horizontally.
  final TextAlign? textAlign;

  /// How visual overflow is handled.
  final TextOverflow? overflow;

  /// Maximum number of displayed lines.
  final int? maxLines;

  /// Whether the text may wrap at soft line breaks.
  final bool? softWrap;

  /// Optional text scaling strategy.
  final TextScaler? textScaler;

  /// Accessibility label that replaces [data] in semantics.
  final String? semanticsLabel;

  TextStyle _resolveStyle(TsaiTypographyTokens tokens);

  String get _displayData => data;

  @override
  Widget build(BuildContext context) {
    final tokens = TsaiThemeTokens.of(context);
    return Text(
      _displayData,
      style: _resolveStyle(
        tokens.typography,
      ).copyWith(color: color ?? tokens.colors.contentPrimary),
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      textScaler: textScaler,
      semanticsLabel: semanticsLabel ?? (_displayData == data ? null : data),
    );
  }
}
