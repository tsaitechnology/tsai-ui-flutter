import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tsai_ui/tsai_ui.dart';

void main() {
  testWidgets('maps every typography widget to its Penpot text role', (
    tester,
  ) async {
    final type = TsaiThemeTokens.light.typography;
    final cases = <(TsaiText, TextStyle)>[
      (
        const TsaiTextHeading('Text', size: TsaiHeadingSize.extraLarge),
        type.headingExtraLarge,
      ),
      (
        const TsaiTextHeading('Text', size: TsaiHeadingSize.large),
        type.headingLarge,
      ),
      (
        const TsaiTextHeading('Text', size: TsaiHeadingSize.medium),
        type.headingMedium,
      ),
      (
        const TsaiTextHeading('Text', size: TsaiHeadingSize.small),
        type.headingSmall,
      ),
      (
        const TsaiTextBody(
          'Text',
          size: TsaiBodySize.large,
          weight: TsaiTextWeight.medium,
        ),
        type.bodyLargeMedium,
      ),
      (
        const TsaiTextBody(
          'Text',
          size: TsaiBodySize.large,
          weight: TsaiTextWeight.regular,
        ),
        type.bodyLarge,
      ),
      (
        const TsaiTextBody(
          'Text',
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.medium,
        ),
        type.bodyMediumMedium,
      ),
      (
        const TsaiTextBody(
          'Text',
          size: TsaiBodySize.medium,
          weight: TsaiTextWeight.regular,
        ),
        type.bodyMedium,
      ),
      (
        const TsaiTextButton('Text', size: TsaiButtonTextSize.large),
        type.buttonLarge,
      ),
      (
        const TsaiTextButton('Text', size: TsaiButtonTextSize.medium),
        type.buttonMedium,
      ),
      (
        const TsaiTextCaption(
          'Text',
          size: TsaiCaptionSize.medium,
          weight: TsaiTextWeight.medium,
        ),
        type.captionMedium,
      ),
      (
        const TsaiTextCaption(
          'Text',
          size: TsaiCaptionSize.medium,
          weight: TsaiTextWeight.regular,
        ),
        type.captionMediumRegular,
      ),
      (
        const TsaiTextCaption(
          'Text',
          size: TsaiCaptionSize.small,
          weight: TsaiTextWeight.medium,
        ),
        type.captionSmall,
      ),
      (
        const TsaiTextCaption(
          'Text',
          size: TsaiCaptionSize.small,
          weight: TsaiTextWeight.regular,
        ),
        type.captionSmallRegular,
      ),
      (
        const TsaiTextMonoHeading('Text', size: TsaiMonoHeadingSize.extraLarge),
        type.monoHeadingExtraLarge,
      ),
      (
        const TsaiTextMonoHeading('Text', size: TsaiMonoHeadingSize.large),
        type.monoHeadingLarge,
      ),
      (
        const TsaiTextMonoBody('Text', size: TsaiBodySize.large),
        type.monoBodyLarge,
      ),
      (
        const TsaiTextMonoBody('Text', size: TsaiBodySize.medium),
        type.monoBodyMedium,
      ),
      (
        const TsaiTextMonoCaption('Text', weight: TsaiTextWeight.medium),
        type.monoCaption,
      ),
      (
        const TsaiTextMonoCaption('Text', weight: TsaiTextWeight.regular),
        type.monoCaptionRegular,
      ),
    ];

    for (final (widget, expected) in cases) {
      await _pump(tester, child: widget);

      final actual = tester.widget<Text>(find.byType(Text)).style!;
      expect(actual.fontFamily, expected.fontFamily);
      expect(actual.fontSize, expected.fontSize);
      expect(actual.fontWeight, expected.fontWeight);
      expect(actual.letterSpacing, 0);
      expect(actual.height, expected.height);
    }
  });

  testWidgets('uses the active semantic content color', (tester) async {
    const text = TsaiTextHeading('Text', size: TsaiHeadingSize.large);

    await _pump(tester, child: text);
    expect(
      tester.widget<Text>(find.byType(Text)).style!.color,
      TsaiThemeTokens.light.colors.contentPrimary,
    );

    await _pump(tester, theme: TsaiTheme.dark(), child: text);
    expect(
      tester.widget<Text>(find.byType(Text)).style!.color,
      TsaiThemeTokens.dark.colors.contentPrimary,
    );
  });

  testWidgets('forwards controlled Text behavior and semantics', (
    tester,
  ) async {
    const color = Color(0xFF00A884);
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      child: const TsaiTextBody(
        'Visible text',
        size: TsaiBodySize.medium,
        weight: TsaiTextWeight.regular,
        color: color,
        textAlign: TextAlign.end,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        softWrap: false,
        textScaler: TextScaler.noScaling,
        semanticsLabel: 'Accessible text',
      ),
    );

    final text = tester.widget<Text>(find.byType(Text));
    expect(text.style!.color, color);
    expect(text.textAlign, TextAlign.end);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.maxLines, 2);
    expect(text.softWrap, isFalse);
    expect(text.textScaler, TextScaler.noScaling);
    expect(find.bySemanticsLabel('Accessible text'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('small captions render uppercase and preserve source semantics', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      child: const TsaiTextCaption(
        'Account status',
        size: TsaiCaptionSize.small,
        weight: TsaiTextWeight.regular,
      ),
    );

    expect(find.text('ACCOUNT STATUS'), findsOneWidget);
    expect(find.bySemanticsLabel('Account status'), findsOneWidget);
    semantics.dispose();
  });
}

Future<void> _pump(
  WidgetTester tester, {
  required Widget child,
  ThemeData? theme,
}) => tester.pumpWidget(
  MaterialApp(
    theme: theme ?? TsaiTheme.light(),
    themeAnimationDuration: Duration.zero,
    home: Scaffold(body: child),
  ),
);
